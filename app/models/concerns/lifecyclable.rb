module Lifecyclable
  extend ActiveSupport::Concern

  included do
    LIFECYCLE_DAYS_BEFORE_DELETION = 30

    LIFECYCLE_ALL = 'all'
    LIFECYCLE_PUBLISHED = 'published'
    LIFECYCLE_DRAFT = 'draft'
    LIFECYCLE_TRASH = 'trash'

    LIFECYCLE_STATUSES = [
      LIFECYCLE_ALL,
      LIFECYCLE_PUBLISHED,
      LIFECYCLE_DRAFT,
      LIFECYCLE_TRASH
    ]

    scope :at_lifecycle, -> (status, language) {
      case status
      when LIFECYCLE_PUBLISHED
        published_in(language)
      when LIFECYCLE_DRAFT
        draft_in(language)
      when LIFECYCLE_TRASH
        only_deleted
      else
        # Status nil or all
        # -> no additional scope :)
      end
    }
  end

end
