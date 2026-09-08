# == Schema Information
#
# Table name: user_roles
#
#  id            :uuid             not null, primary key
#  role          :integer          not null, uniquely indexed => [user_id, scope_type, scope_id]
#  scope_type    :string           indexed => [scope_id], uniquely indexed => [user_id, role, scope_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  scope_id      :uuid             indexed => [scope_type], uniquely indexed => [user_id, role, scope_type]
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed, uniquely indexed => [role, scope_type, scope_id]
#
# Indexes
#
#  index_user_roles_on_scope          (scope_type,scope_id)
#  index_user_roles_on_university_id  (university_id)
#  index_user_roles_on_user_id        (user_id)
#  index_user_roles_uniqueness        (user_id,role,scope_type,scope_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_318345354e  (user_id => users.id)
#  fk_rails_c177139056  (university_id => universities.id)
#
class User::Role < ApplicationRecord

  # Rôles qui se rattachent à une cible (site ou formation)
  ROLES_WITH_SCOPE = {
    'contributor'     => 'Communication::Website',
    'author'          => 'Communication::Website',
    'website_manager' => 'Communication::Website',
    'teacher' => 'Education::Program',
    'program_manager' => 'Education::Program',
  }.freeze

  enum :role, {
    contributor: 4,
    author: 5,
    teacher: 10,
    program_manager: 12,
    website_manager: 15,
    alumni_manager: 18,
    admin: 20,
  }

  belongs_to :user, inverse_of: :roles
  belongs_to :university
  belongs_to :scope, polymorphic: true, optional: true

  before_validation :set_university_from_user
  validate :scope_required_for_scoped_role

  after_create :autoset_favorite_for_website_manager

  def self.scope_type_for(role_name)
    ROLES_WITH_SCOPE[role_name]
  end

  def scope_choice
    scope_id
  end

  def scope_choice=(value)
    self.scope_type = ROLES_WITH_SCOPE[role]
    self.scope_id = value.presence
  end

  def to_s
    [
      I18n.t("activerecord.attributes.user.roles.#{role}"),
      scope&.to_s
    ].compact.join(' — ')
  end

  protected

  def set_university_from_user
    self.university ||= user&.university
  end

  def scope_required_for_scoped_role
    errors.add(:scope, 'is required for this role') if has_scope? && scope_id.blank?
  end

  def has_scope?
    ROLES_WITH_SCOPE[role].present?
  end

  # Quand on confie un site à un responsable, on l'ajoute à ses favoris pour un
  # accès rapide (idempotent). Remplace l'ancien autoset_favorites de User.
  def autoset_favorite_for_website_manager
    return unless website_manager? && scope.is_a?(Communication::Website)
    user&.add_favorite(scope)
  end
end
