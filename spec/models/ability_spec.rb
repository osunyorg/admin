require 'rails_helper'

RSpec.describe Ability, type: :model do
  fixtures :all

  let(:university) { universities(:default_university) }
  let(:site_a) { communication_websites(:website_with_github) }
  let(:site_b) { communication_websites(:website_with_gitlab) }
  let(:program) { education_programs(:default_program) }

  # Construit en mémoire (sans persister) les rôles d'un utilisateur, pour
  # tester Ability sans effet de bord (pas de callbacks, pas d'API externe).
  def user_with(fixture, *roles)
    user = User.find(users(fixture).id)
    user.roles.load_target # charge les éventuels rôles fixtures
    roles.each do |attrs|
      user.roles.build(university: university, **attrs)
    end
    user
  end

  def event_on(website)
    Communication::Website::Agenda::Event.new(
      university_id: university.id,
      communication_website_id: website.id
    )
  end

  describe 'un seul rôle (non-régression)' do
    it 'admin : gère son université mais ne détruit pas de site' do
      ability = Ability.for(users(:admin))
      expect(ability.can?(:manage, University::Organization.new(university_id: university.id))).to be true
      expect(ability.can?(:destroy, Communication::Website.new(university_id: university.id))).to be false
    end

    it 'visitor (aucun rôle) : aucun droit' do
      ability = Ability.for(users(:alumnus))
      expect(ability.can?(:manage, Communication::Website.new(university_id: university.id))).to be false
    end
  end

  describe 'scope par rôle' do
    it 'un author n\'a de droits que sur SES sites' do
      user = user_with(:alumnus, { role: :author, scope: site_a })
      ability = Ability.for(user)

      expect(ability.can?(:create, event_on(site_a))).to be true
      # site_b n'est pas dans son périmètre author
      expect(ability.can?(:create, event_on(site_b))).to be false
    end
  end

  describe 'rôles multiples' do
    it 'est additif : chaque rôle apporte ses droits' do
      author_only = Ability.for(user_with(:alumnus, { role: :author, scope: site_a }))
      author_and_pm = Ability.for(user_with(:alumnus,
                                            { role: :author, scope: site_a },
                                            { role: :program_manager, scope: program }))
      category = Education::Program::Category.new(university_id: university.id)

      # program_manager apporte la gestion des catégories de formation
      expect(author_only.can?(:manage, category)).to be false
      expect(author_and_pm.can?(:manage, category)).to be true
    end

    it 'fusionne du moins au plus privilégié' do
      user = user_with(:server_admin, { role: :website_manager, scope: site_a })
      expect(user.ability_roles).to eq(['website_manager', 'server_admin'])
    end

    it 'le rôle le plus puissant l\'emporte sur un cannot plus restrictif' do
      # server_admin (can :manage, :all) + website_manager (cannot :destroy site).
      # L'ordre de fusion doit préserver le droit de destruction du server_admin.
      user = user_with(:server_admin, { role: :website_manager, scope: site_a })
      website = Communication::Website.new(university_id: university.id)
      expect(Ability.for(user).can?(:destroy, website)).to be true
    end
  end
end
