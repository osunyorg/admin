require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  before do
    # Évite la redirection vers la double authentification dans les tests.
    allow_any_instance_of(User).to receive(:need_two_factor_authentication?).and_return(false)
    sign_in users(:admin)
  end

  describe 'GET /admin/:lang/users/:id/edit' do
    it 'renders the multi-role form' do
      get edit_admin_user_path(users(:alumnus), lang: :fr)

      expect(response).to have_http_status(:ok)
      # Section des rôles imbriqués + bouton cocoon
      expect(response.body).to include('id="user_roles"')
      expect(response.body).to include('Ajouter un rôle')
    end

    it 'pre-selects existing roles and their scope' do
      site = communication_websites(:website_with_github)
      target = User.find(users(:alumnus).id)
      target.grant_role!(:website_manager, scope: site)

      get edit_admin_user_path(target, lang: :fr)

      expect(response).to have_http_status(:ok)
      role_select = response.body[/<select[^>]*data-user-role-role[^>]*>.*?<\/select>/m]
      expect(role_select).to match(/value="website_manager"[^>]*selected="selected"|selected="selected"[^>]*value="website_manager"/)
      # Le rôle visitor (sans droit) n'est jamais proposé dans le select de rôle
      expect(role_select).not_to include('value="visitor"')
      # La cible est transmise par son seul uuid, présélectionnée
      scope_select = response.body[/<select[^>]*data-user-role-scope[^>]*>.*?<\/select>/m]
      expect(scope_select).to match(/value="#{site.id}"[^>]*selected="selected"|selected="selected"[^>]*value="#{site.id}"/)
      # .nested-fields ne doit pas porter d-flex, sinon cocoon ne peut pas la
      # masquer (display:none écrasé par flex !important) — pas de feedback visuel.
      nested_fields_class = response.body[/class="(nested-fields[^"]*)"/, 1]
      expect(nested_fields_class).not_to include('d-flex')
    end
  end

  describe 'PATCH /admin/:lang/users/:id' do
    it 'assigns scoped roles through nested attributes' do
      site = communication_websites(:website_with_github)

      patch admin_user_path(users(:alumnus), lang: :fr), params: {
        user: {
          roles_attributes: {
            '0' => { role: 'website_manager', scope_choice: site.id }
          }
        }
      }

      user = User.find(users(:alumnus).id)
      expect(user.roles.pluck(:role)).to eq(['website_manager'])
      expect(user.roles.first.scope).to eq(site)
      expect(user.role).to eq('website_manager')
    end

    it 'removes a role via _destroy (cocoon remove link)' do
      site = communication_websites(:website_with_github)
      target = User.find(users(:alumnus).id)
      role = target.grant_role!(:website_manager, scope: site)

      # La ligne masquée par cocoon resoumet rôle + cible en plus de _destroy.
      patch admin_user_path(target, lang: :fr), params: {
        user: {
          roles_attributes: {
            '0' => { id: role.id, role: 'website_manager', scope_choice: site.id, _destroy: '1' }
          }
        }
      }

      target.reload
      expect(target.roles).to be_empty
      expect(target.role).to eq('visitor') # cache retombe sur visitor
    end
  end
end
