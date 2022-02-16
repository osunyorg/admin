# == Schema Information
#
# Table name: communication_website_blocks
#
#  id                       :uuid             not null, primary key
#  about_type               :string           indexed => [about_id]
#  data                     :jsonb
#  position                 :integer          default(0), not null
#  template                 :integer          default(NULL), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed => [about_type]
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_blocks_on_about                     (about_type,about_id)
#  index_communication_website_blocks_on_communication_website_id  (communication_website_id)
#  index_communication_website_blocks_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_18291ef65f  (university_id => universities.id)
#  fk_rails_75bd7c8d6c  (communication_website_id => communication_websites.id)
#
class Communication::Website::Block < ApplicationRecord
  include WithPosition

  belongs_to :university
  belongs_to :website, foreign_key: :communication_website_id
  belongs_to :about, polymorphic: true

  enum template: {
    organization_chart: 100,
    partners: 200
  }

  def data=(value)
    value = JSON.parse value if value.is_a? String
    super(value)
  end

  def git_dependencies
    m = "git_dependencies_for_#{template}"
    respond_to?(m, true) ? send(m) : []
  end

  def last_ordered_element
    about.blocks.ordered.last
  end

  def to_s
    "Bloc #{position}"
  end

  protected

  def git_dependencies_for_organization_chart
    dependencies = []
    data['elements'].each do |element|
      element['persons'].each do |person|
        id = person['id']
        next if id.blank?
        person = university.people.find id
        next if person.nil?
        dependencies += [person]
        dependencies += person.active_storage_blobs
      end
    end
    dependencies.uniq
  end
end
