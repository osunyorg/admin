module User::WithRoles
  extend ActiveSupport::Concern

  included do
    attr_accessor :modified_by

    enum role: { visitor: 0, teacher: 10, program_manager: 12, admin: 20, server_admin: 30 }

    scope :for_role, -> (role) { where(role: role) }

    before_validation :set_default_role, on: :create
    before_validation :check_modifier_role

    def managed_roles
      User.roles.map do |role_name, role_id|
        next if role_id > User.roles[role]
        role_name
      end.compact
    end

    protected

    def check_modifier_role
      errors.add(:role, 'cannot be set to this role') if modified_by && !modified_by.managed_roles.include?(self.role)
    end

    def set_default_role
      return if server_admin?
      if User.all.empty?
        self.role = :server_admin
      elsif university.users.not_server_admin.empty?
        self.role = :admin
      end
    end

  end
end
