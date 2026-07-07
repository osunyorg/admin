# == Schema Information
#
# Table name: user_roles
#
#  id            :uuid             not null, primary key
#  role          :integer          not null, uniquely indexed => [user_id, scope_type, scope_id]
#  scope_type    :string           indexed => [scope_id], uniquely indexed => [user_id, role, scope_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  scope_id      :uuid             indexed => [scope_type], uniquely indexed => [user_id, role, scope_type]
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed, uniquely indexed => [role, scope_type, scope_id]
#
# Indexes
#
#  index_user_roles_on_scope          (scope_type,scope_id)
#  index_user_roles_on_university_id  (university_id)
#  index_user_roles_on_user_id        (user_id)
#  index_user_roles_uniqueness        (user_id,role,scope_type,scope_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_318345354e  (user_id => users.id)
#  fk_rails_c177139056  (university_id => universities.id)
#
class User::Role < ApplicationRecord
  self.table_name = 'user_roles'

  # Encodage partagé par User (colonne `role`, cache du rôle le plus élevé) et
  # par User::Role (source de vérité, scopée). Les entiers sont figés : ils sont
  # stockés en base et utilisés par la migration de backfill.
  ROLES = {
    visitor: 0,
    contributor: 4,
    author: 5,
    teacher: 10,
    program_manager: 12,
    website_manager: 15,
    alumni_manager: 18,
    admin: 20,
    server_admin: 30
  }.freeze

  # Rôles qui se rattachent à une ou plusieurs cibles (sites / formations).
  # Les autres (visitor, teacher, admin, server_admin) sont globaux.
  SCOPED_ROLES = {
    'contributor'     => 'Communication::Website',
    'author'          => 'Communication::Website',
    'website_manager' => 'Communication::Website',
    'program_manager' => 'Education::Program'
  }.freeze

  # Source de vérité des droits : un utilisateur a autant de lignes que de
  # couples (rôle, cible). Le scope est polymorphe et facultatif (les rôles
  # globaux — teacher, admin, server_admin — n'ont pas de cible).
  enum :role, ROLES

  belongs_to :user, inverse_of: :roles
  belongs_to :university
  belongs_to :scope, polymorphic: true, optional: true

  before_validation :set_university_from_user
  before_validation :assign_scope_type_from_role
  validate :scope_required_for_scoped_role

  # TODO(roles-cache): ces deux callbacks maintiennent le cache User#role ; ils
  # disparaissent si l'équipe décide de supprimer le cache (cf. User::Role).
  after_save :refresh_user_cached_role
  after_destroy :refresh_user_cached_role
  after_create :autoset_favorite_for_website_manager

  def to_s
    [
      I18n.t("activerecord.attributes.user.roles.#{role}"),
      scope&.to_s
    ].compact.join(' — ')
  end

  # Pilote la cible via un seul champ de formulaire : on ne transmet que l'uuid,
  # le type est déduit du rôle (cf. assign_scope_type_from_role).
  def scope_choice
    scope_id
  end

  def scope_choice=(value)
    self.scope_id = value.presence
  end

  protected

  def set_university_from_user
    self.university ||= user&.university
  end

  # Le type de cible découle du rôle : pas besoin de le transmettre depuis le
  # formulaire. Un rôle global n'a aucune cible.
  def assign_scope_type_from_role
    if global_role?
      self.scope_type = nil
      self.scope_id = nil
    else
      self.scope_type = User::Role::SCOPED_ROLES[role]
    end
  end

  def scope_required_for_scoped_role
    errors.add(:scope, 'is required for this role') if !global_role? && scope_id.blank?
  end

  def global_role?
    User::Role::SCOPED_ROLES[role].nil?
  end

  def refresh_user_cached_role
    user&.refresh_cached_role!
  end

  # Quand on confie un site à un responsable, on l'ajoute à ses favoris pour un
  # accès rapide (idempotent). Remplace l'ancien autoset_favorites de User.
  def autoset_favorite_for_website_manager
    return unless website_manager? && scope.is_a?(Communication::Website)
    user&.add_favorite(scope)
  end
end
