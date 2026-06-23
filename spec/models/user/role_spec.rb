require 'rails_helper'

RSpec.describe User::Role, type: :model do
  fixtures :all

  let(:site_a) { communication_websites(:website_with_github) }
  let(:program) { education_programs(:default_program) }
  let(:user) { User.find(users(:alumnus).id) } # visitor, sans rôle au départ
  let(:admin) { users(:admin) }

  describe 'assignation via attributs imbriqués (formulaire)' do
    it 'crée des rôles scopés et rafraîchit le cache role' do
      user.modified_by = admin
      user.update!(roles_attributes: [
        { role: 'website_manager', scope_choice: site_a.id },
        { role: 'admin' }
      ])
      user.reload

      expect(user.roles.pluck(:role)).to match_array(%w[website_manager admin])
      website_manager_role = user.roles.find_by(role: 'website_manager')
      expect(website_manager_role.scope).to eq(site_a)
      expect(website_manager_role.university).to eq(user.university)
      # cache = rôle le plus élevé détenu
      expect(user.role).to eq('admin')
    end

    it 'ne transmet que l\'uuid ; le type de cible est déduit du rôle' do
      role = user.roles.build(role: 'program_manager')
      role.scope_choice = program.id
      role.valid? # déclenche la déduction du type depuis le rôle
      expect(role.scope_type).to eq('Education::Program')
      expect(role.scope).to eq(program)
      expect(role.scope_choice).to eq(program.id)
    end
  end

  describe 'garde-fou du modificateur' do
    it 'refuse un rôle au-dessus de ce que le modificateur gère' do
      user.modified_by = admin # un admin ne gère pas server_admin
      user.roles_attributes = [{ role: 'server_admin' }]

      expect(user.save).to be false
      expect(user.errors[:base]).to be_present
    end
  end

  describe 'cohérence scope / rôle' do
    it 'efface la cible d\'un rôle global' do
      role = user.roles.build(role: 'admin', scope: site_a)
      expect(role).to be_valid
      expect(role.scope).to be_nil
    end

    it 'exige une cible pour un rôle scopé' do
      role = user.roles.build(role: 'website_manager')
      expect(role).to be_invalid
    end

    it 'force le type de cible selon le rôle (pas de mauvais type possible)' do
      role = user.roles.build(role: 'website_manager', scope_id: program.id)
      role.valid?
      expect(role.scope_type).to eq('Communication::Website')
    end
  end

  describe 'grant_role! / has_role?' do
    it 'est idempotent et maintient le cache' do
      user.grant_role!(:website_manager, scope: site_a)
      user.grant_role!(:website_manager, scope: site_a) # idempotent
      user.reload

      expect(user.roles.where(role: 'website_manager').count).to eq(1)
      expect(user.has_role?('website_manager')).to be true
      expect(user.role).to eq('website_manager')
    end
  end
end
