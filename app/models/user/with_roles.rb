module User::WithRoles
  extend ActiveSupport::Concern

  included do
    attr_accessor :modified_by

    enum role: { visitor: 0, admin: 20, superadmin: 30 }

    scope :for_role, -> (role) { where(role: role) }

    before_validation :check_modifier_role

    def roles_managed
      User.roles.map do |role_name, role_id|
        next if role_id > User.roles[role]
        role_name
      end.compact
    end

    protected

    def check_modifier_role
      errors.add(:role, 'cannot be set to this role') if modified_by && !modified_by.roles_managed.include?(self.role)
    end

  end
end
