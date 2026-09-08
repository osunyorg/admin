module User::WithRoles
  extend ActiveSupport::Concern

  included do
    attr_accessor :modified_by, :just_autopromoted

    # TODO(multiroles) remove
    enum :role, {
      visitor: 0,
      contributor: 4,
      author: 5,
      teacher: 10,
      program_manager: 12,
      website_manager: 15,
      alumni_manager: 18,
      admin: 20,
      server_admin: 30
    }

    has_many :roles,
             class_name: 'User::Role',
             dependent: :destroy,
             inverse_of: :user
    accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true

    # TODO(multiroles) écrire ça en fonction des rôles liés au user
    scope :for_role, -> (role, language = nil) { where(role: role) }

    before_validation :set_default_role, on: :create
    validate :assigned_roles_within_modifier_scope
    after_create :bootstrap_role_assignment
    after_create :set_university_autopromote_option, if: :just_autopromoted

    def self.roles_with_access_to_global_menu
      roles.keys - ['contributor', 'author', 'website_manager']
    end

    # Rôles effectifs (distincts), ordonnés du moins au plus privilégié.
    # L'ordre est volontaire : Ability fusionne les abilities dans cet ordre pour
    # que les règles du rôle le plus puissant soient déclarées en dernier et
    # l'emportent (CanCanCan évalue de la dernière règle définie à la première).
    def ability_roles
      roles.map(&:role).uniq.sort_by { |name| self.class.roles[name] }
    end

    # Détient ce rôle (sur n'importe quelle cible) ?
    def has_role?(name)
      roles.any? { |user_role| user_role.role == name.to_s }
    end

    # Cibles (records) attachées à un rôle donné.
    def scopes_for(role_name)
      roles.select { |user_role| user_role.role == role_name.to_s }
           .filter_map(&:scope)
    end

    def grant_role!(role_name, scope: nil)
      roles.find_or_create_by!(
        role: role_name,
        scope_type: scope&.class&.base_class&.name,
        scope_id: scope&.id
      )
    end

    def managed_roles
      can_grant_roles? ? User::Role.roles.keys : []
    end

    def can_grant_roles?
      server_admin? || has_role?('admin')
    end

    def managed_websites
      if has_role?('server_admin')
        Communication::Website.all
      elsif has_role?('admin')
        Communication::Website.where(university_id: university_id)
      elsif has_role?('website_manager')
        Communication::Website.where(id: scopes_for('website_manager').map(&:id))
      else
        Communication::Website.none
      end
    end

    def can_display_global_menu?
      (ability_roles & User.roles_with_access_to_global_menu).any?
    end

    protected

    # Empêche d'attribuer un rôle au-dessus de ce que le modificateur gère.
    def assigned_roles_within_modifier_scope
      return unless modified_by
      assigned = roles.reject(&:marked_for_destruction?).map(&:role).uniq
      forbidden = assigned - modified_by.managed_roles
      errors.add(:base, 'cannot assign a role above your own') if forbidden.any?
    end

    def set_default_role
      return if server_admin?
      if User.all.empty?
        # Premier user de toutes les instances
        self.role = :server_admin
      elsif !university.admin_already_auto_promoted? && university.users.not_server_admin.empty?
        # Premier user de l'instsance
        self.role = :admin
        self.just_autopromoted = true
      end
    end

    def set_university_autopromote_option
      university.update(admin_already_auto_promoted: true)
    end

  end
end
