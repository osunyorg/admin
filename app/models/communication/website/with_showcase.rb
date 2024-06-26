module Communication::Website::WithShowcase
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :showcase_tags,
                            class_name: 'Communication::Website::Showcase::Tag',
                            join_table: :communication_website_showcase_tags_websites,
                            foreign_key: :communication_website_id,
                            association_foreign_key: :communication_website_showcase_tag_id

    scope :ordered_for_showcase, -> { 
      order(highlighted_in_showcase: :desc, created_at: :desc)
    }
    scope :in_showcase, -> { 
      in_production.where(in_showcase: true)
                   .ordered_for_showcase
    }
  end
end