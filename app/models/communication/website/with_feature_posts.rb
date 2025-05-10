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

  def feature_posts_name(language)
    begin
      special_page(Communication::Website::Page::CommunicationPost).best_localization_for(language)
    rescue
      Communication::Website::Post.model_name.human(count: 2)
    end
  end

  def feature_posts_dependencies
    posts +
    post_categories
  end
end