module WithWebsitePreviousLinks
  extend ActiveSupport::Concern

  included do

    has_many  :previous_links,
              class_name: "Communication::Website::PreviousLink",
              as: :about,
              dependent: :destroy

    after_validation :manage_previous_links, on: [:create, :update]

    def manage_previous_links
      websites_for_self.each do |website|
        old_permalink = previous_permalink_for_website(website)
        new_permalink = permalink_for_website(website)

        # If the object had a permalink and now is different, we create a previous link
        previous_links.create(website: website, link: old_permalink) if old_permalink.present? && new_permalink != old_permalink
      end
    end

  end
end
