module University::Person::WithRealmCommunication
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :communication_website_posts,
              class_name: 'Communication::Website::Post',
              foreign_key: :university_person_id,
              association_foreign_key: :communication_website_post_id

    has_many  :author_websites,
              -> { distinct },
              through: :communication_website_posts,
              source: :website

    has_many  :communication_extranet_posts,
              class_name: 'Communication::Extranet::Post',
              foreign_key: :author_id,
              dependent: :nullify

    has_many  :author_extranets,
              -> { distinct },
              through: :communication_extranet_posts,
              source: :extranet
  end

  def posts
    communication_website_posts + communication_extranet_posts
  end
end