require "test_helper"

# rails test test/models/user/role_test.rb
class User::RoleTest < ActiveSupport::TestCase
  def site_a
    @site_a ||= website_with_github
  end

  def program
    @program ||= education_programs(:default_program)
  end

  # alumnus est un visitor sans rôle au départ.
  def user
    @user ||= User.find(alumnus.id)
  end

  test "les attributs imbriqués créent des rôles scopés et rafraîchissent le cache" do
    user.modified_by = admin
    user.update!(roles_attributes: [
      { role: "website_manager", scope_choice: site_a.id },
      { role: "admin" }
    ])
    user.reload

    assert_equal %w[admin website_manager], user.roles.pluck(:role).sort
    website_manager_role = user.roles.find_by(role: "website_manager")
    assert_equal site_a, website_manager_role.scope
    assert_equal user.university, website_manager_role.university
    # cache = rôle le plus élevé détenu
    assert_equal "admin", user.role
  end

  test "ne transmet que l'uuid ; le type de cible est déduit du rôle" do
    role = user.roles.build(role: "program_manager")
    role.scope_choice = program.id
    role.valid? # déclenche la déduction du type depuis le rôle
    assert_equal "Education::Program", role.scope_type
    assert_equal program, role.scope
    assert_equal program.id, role.scope_choice
  end

  test "refuse un rôle au-dessus de ce que le modificateur gère" do
    user.modified_by = admin # un admin ne gère pas server_admin
    user.roles_attributes = [{ role: "server_admin" }]

    assert_not user.save
    assert user.errors[:base].present?
  end

  test "efface la cible d'un rôle global" do
    role = user.roles.build(role: "admin", scope: site_a)
    assert role.valid?
    assert_nil role.scope
  end

  test "exige une cible pour un rôle scopé" do
    role = user.roles.build(role: "website_manager")
    assert_not role.valid?
  end

  test "force le type de cible selon le rôle (pas de mauvais type possible)" do
    role = user.roles.build(role: "website_manager", scope_id: program.id)
    role.valid?
    assert_equal "Communication::Website", role.scope_type
  end

  test "grant_role! est idempotent et maintient le cache" do
    user.grant_role!(:website_manager, scope: site_a)
    user.grant_role!(:website_manager, scope: site_a) # idempotent
    user.reload

    assert_equal 1, user.roles.where(role: "website_manager").count
    assert user.has_role?("website_manager")
    assert_equal "website_manager", user.role
  end
end
