# == Schema Information
#
# Table name: communication_extranet_posts
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string
#  summary               :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  author_id             :uuid             indexed
#  extranet_id           :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_posts_on_author_id      (author_id)
#  index_communication_extranet_posts_on_extranet_id    (extranet_id)
#  index_communication_extranet_posts_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_0232de42a1  (university_id => universities.id)
#  fk_rails_4341823eab  (extranet_id => communication_extranets.id)
#  fk_rails_86cc935add  (author_id => university_people.id)
#
class Communication::Extranet::Post < ApplicationRecord
  include Sanitizable
  include WithUniversity
  include WithFeaturedImage
  include WithBlocks
  include WithPermalink
  include WithSlug

  belongs_to :author, class_name: 'University::Person'
  belongs_to :extranet, class_name: 'Communication::Extranet'
end
