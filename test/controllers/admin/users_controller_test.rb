require "test_helper"

# rails test test/controllers/admin/users_controller_test.rb
class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_with_2fa(admin)
  end

  test "edit affiche le formulaire multi-rôles" do
    get edit_admin_user_path(alumnus, lang: french)

    assert_response :success
    assert_includes response.body, 'id="user_roles"'
    assert_includes response.body, "Ajouter un rôle"
  end

  test "edit présélectionne les rôles existants et leur cible, sans visitor" do
    target = User.find(alumnus.id)
    target.grant_role!(:website_manager, scope: website_with_github)

    get edit_admin_user_path(target, lang: french)
    assert_response :success

    role_select = response.body[/<select[^>]*data-user-role-role[^>]*>.*?<\/select>/m]
    assert_match(/value="website_manager"[^>]*selected="selected"|selected="selected"[^>]*value="website_manager"/, role_select)
    # Le rôle visitor (sans droit) n'est jamais proposé.
    assert_not_includes role_select, 'value="visitor"'

    # La cible est transmise par son seul uuid, présélectionnée.
    scope_select = response.body[/<select[^>]*data-user-role-scope[^>]*>.*?<\/select>/m]
    assert_match(/value="#{website_with_github.id}"[^>]*selected="selected"|selected="selected"[^>]*value="#{website_with_github.id}"/, scope_select)

    # .nested-fields ne doit pas porter d-flex, sinon cocoon ne peut pas la
    # masquer (display:none écrasé par flex !important) — pas de feedback visuel.
    nested_fields_class = response.body[/class="(nested-fields[^"]*)"/, 1]
    assert_not_includes nested_fields_class, "d-flex"
  end

  test "attribue des rôles scopés via les attributs imbriqués" do
    patch admin_user_path(alumnus, lang: french), params: {
      user: {
        roles_attributes: {
          "0" => { role: "website_manager", scope_choice: website_with_github.id }
        }
      }
    }

    target = User.find(alumnus.id)
    assert_equal ["website_manager"], target.roles.pluck(:role)
    assert_equal website_with_github, target.roles.first.scope
    assert_equal "website_manager", target.role
  end

  test "supprime un rôle via _destroy (lien de suppression cocoon)" do
    target = User.find(alumnus.id)
    role = target.grant_role!(:website_manager, scope: website_with_github)

    # La ligne masquée par cocoon resoumet rôle + cible en plus de _destroy.
    patch admin_user_path(target, lang: french), params: {
      user: {
        roles_attributes: {
          "0" => { id: role.id, role: "website_manager", scope_choice: website_with_github.id, _destroy: "1" }
        }
      }
    }

    target.reload
    assert_empty target.roles
    assert_equal "visitor", target.role # le cache retombe sur visitor
  end
end
