module User::WithRoles
  extend ActiveSupport::Concern

  included do
    attr_accessor :modified_by

    enum role: { 
      visitor: 0, 
      contributor: 4, 
      author: 5, 
      teacher: 10, 
      program_manager: 12, 
      website_manager: 15, 
      admin: 20, 
      server_admin: 30 
    }

    has_and_belongs_to_many :programs_to_manage,
                            class_name: 'Education::Program',
                            join_table: :education_programs_users,
                            association_foreign_key: :education_program_id

    has_and_belongs_to_many :websites_to_manage,
                            class_name: 'Communication::Website',
                            join_table: :communication_websites_users,
                            association_foreign_key: :communication_website_id

    scope :for_role, -> (role) { where(role: role) }

    before_validation :set_default_role, on: :create
    before_validation :check_modifier_role

    def self.roles_with_access_to_global_menu
      roles.keys - ['contributor', 'author', 'website_manager']
    end

    def managed_roles
      User.roles.map do |role_name, role_id|
        next if role_id > User.roles[role]
        role_name
      end.compact
    end

    def can_display_global_menu?
      User.roles_with_access_to_global_menu.include?(role)
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
