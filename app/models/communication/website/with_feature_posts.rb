module Communication::Website::WithFeaturePosts
  extend ActiveSupport::Concern

  included do
    has_many    :posts,
                foreign_key: :communication_website_id,
                dependent: :destroy

    has_many    :authors, -> { distinct }, through: :posts

    has_many    :post_categories,
                class_name: 'Communication::Website::Post::Category',
                foreign_key: :communication_website_id,
                dependent: :destroy    

    scope :with_feature_posts, -> { where(feature_posts: true) }
  end

end