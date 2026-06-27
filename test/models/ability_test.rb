require "test_helper"

# rails test test/models/ability_test.rb
class AbilityTest < ActiveSupport::TestCase
  def program
    @program ||= education_programs(:default_program)
  end

  # Construit en mémoire (sans persister) les rôles d'un utilisateur, pour
  # tester Ability sans effet de bord (pas de callbacks, pas d'API externe).
  def user_with(fixture, *roles)
    user = User.find(users(fixture).id)
    user.roles.load_target # charge les éventuels rôles fixtures
    roles.each do |attrs|
      user.roles.build(university: default_university, **attrs)
    end
    user
  end

  def event_on(website)
    Communication::Website::Agenda::Event.new(
      university_id: default_university.id,
      communication_website_id: website.id
    )
  end

  test "un seul rôle : admin gère son université mais ne détruit pas de site" do
    ability = Ability.for(admin)
    assert ability.can?(:manage, University::Organization.new(university_id: default_university.id))
    assert_not ability.can?(:destroy, Communication::Website.new(university_id: default_university.id))
  end

  test "visitor (aucun rôle) : aucun droit" do
    ability = Ability.for(alumnus)
    assert_not ability.can?(:manage, Communication::Website.new(university_id: default_university.id))
  end

  test "un author n'a de droits que sur SES sites" do
    user = user_with(:alumnus, { role: :author, scope: website_with_github })
    ability = Ability.for(user)
    assert ability.can?(:create, event_on(website_with_github))
    assert_not ability.can?(:create, event_on(website_with_gitlab))
  end

  test "les rôles sont additifs : chacun apporte ses droits" do
    author_only = Ability.for(user_with(:alumnus, { role: :author, scope: website_with_github }))
    author_and_pm = Ability.for(user_with(:alumnus,
                                          { role: :author, scope: website_with_github },
                                          { role: :program_manager, scope: program }))
    category = Education::Program::Category.new(university_id: default_university.id)

    assert_not author_only.can?(:manage, category)
    assert author_and_pm.can?(:manage, category)
  end

  test "les rôles fusionnent du moins au plus privilégié" do
    user = user_with(:server_admin, { role: :website_manager, scope: website_with_github })
    assert_equal ["website_manager", "server_admin"], user.ability_roles
  end

  test "le rôle le plus puissant l'emporte sur un cannot plus restrictif" do
    # server_admin (can :manage, :all) + website_manager (cannot :destroy site) :
    # l'ordre de fusion doit préserver le droit de destruction du server_admin.
    user = user_with(:server_admin, { role: :website_manager, scope: website_with_github })
    website = Communication::Website.new(university_id: default_university.id)
    assert Ability.for(user).can?(:destroy, website)
  end
end
