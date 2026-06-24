class CreateUserRoles < ActiveRecord::Migration[8.1]
  def up
    create_table :user_roles, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :university, type: :uuid, null: false, foreign_key: true
      t.integer :role, null: false
      t.references :scope, type: :uuid, polymorphic: true, null: true
      t.timestamps
    end
    add_index :user_roles,
              [:user_id, :role, :scope_type, :scope_id],
              unique: true,
              name: "index_user_roles_uniqueness"

    backfill_from_existing_roles
  end

  def down
    drop_table :user_roles
  end

  private

  # Encodage de l'enum User::ROLES (cf. User::WithRoles) :
  #   contributor 4, author 5, website_manager 15  -> scopés sur des sites
  #   program_manager 12                            -> scopé sur des formations
  #   teacher 10, admin 20, server_admin 30         -> globaux (sans scope)
  #   visitor 0                                     -> pas de ligne (aucun droit)
  def backfill_from_existing_roles
    # Rôles globaux : une ligne sans scope
    execute <<~SQL
      INSERT INTO user_roles (id, user_id, university_id, role, created_at, updated_at)
      SELECT public.gen_random_uuid(), u.id, u.university_id, u.role, now(), now()
      FROM users u
      WHERE u.role IN (10, 20, 30)
    SQL

    # Rôles scopés sur des sites : une ligne par site géré
    execute <<~SQL
      INSERT INTO user_roles (id, user_id, university_id, role, scope_type, scope_id, created_at, updated_at)
      SELECT public.gen_random_uuid(), u.id, u.university_id, u.role,
             'Communication::Website', cwu.communication_website_id, now(), now()
      FROM users u
      JOIN communication_websites_users cwu ON cwu.user_id = u.id
      WHERE u.role IN (4, 5, 15)
    SQL

    # Rôle scopé sur des formations : une ligne par formation gérée
    execute <<~SQL
      INSERT INTO user_roles (id, user_id, university_id, role, scope_type, scope_id, created_at, updated_at)
      SELECT public.gen_random_uuid(), u.id, u.university_id, u.role,
             'Education::Program', epu.education_program_id, now(), now()
      FROM users u
      JOIN education_programs_users epu ON epu.user_id = u.id
      WHERE u.role = 12
    SQL
    # Un rôle scopé sans aucune cible n'accordait déjà aucun droit : on ne crée
    # pas de ligne pour ces utilisateurs (ils deviennent de fait visiteurs).
  end
end
