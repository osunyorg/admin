# == Schema Information
#
# Table name: communication_blocks
#
#  id            :uuid             not null, primary key
#  about_type    :string           indexed => [about_id]
#  data          :jsonb
#  position      :integer          default(0), not null
#  template_kind :integer          default(NULL), not null
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed => [about_type]
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_blocks_on_university_id  (university_id)
#  index_communication_website_blocks_on_about  (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_18291ef65f  (university_id => universities.id)
#
class Communication::Block < ApplicationRecord
  include WithUniversity
  include WithPosition

  belongs_to :about, polymorphic: true

  has_many_attached :template_images

  enum template_kind: {
    chapter: 50,
    organization_chart: 100,
    partners: 200,
    gallery: 300,
    testimonials: 400,
    posts: 500,
    pages: 600,
    timeline: 700,
    definitions: 800,
    push: 900,
  }

  before_save :update_template_images
  after_update_commit :save_and_sync_about

  def data=(value)
    value = JSON.parse value if value.is_a? String
    super(value)
  end

  def git_dependencies
    template.git_dependencies
  end

  def last_ordered_element
    about.blocks.ordered.last
  end

  def template
    @template ||= "Communication::Block::Template::#{template_kind.classify}".constantize.new self
  end

  def to_s
    title.blank?  ? "Block #{position}"
                  : "#{title}"
  end

  protected

  def save_and_sync_about
    about.save_and_sync
  end

  def update_template_images
    self.template_images = template.active_storage_blobs
  end
end
