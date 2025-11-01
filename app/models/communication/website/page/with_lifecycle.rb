module Communication::Website::Page::WithLifecycle
  extend ActiveSupport::Concern

  included do
    LIFECYCLE_ALL = 'all'
    LIFECYCLE_PUBLISHED = 'published'
    LIFECYCLE_DRAFT = 'draft'
    LIFECYCLE_DELETED = 'deleted'

    LIFECYCLE_STATUSES = [
      LIFECYCLE_ALL,
      LIFECYCLE_PUBLISHED,
      LIFECYCLE_DRAFT,
      LIFECYCLE_DELETED
    ]

    scope :at_lifecycle, -> (status, language) {
      case status
      when LIFECYCLE_PUBLISHED
        published_in(language)
      when LIFECYCLE_DRAFT
        draft_in(language)
      when LIFECYCLE_DELETED
        only_deleted
      else
        # Status nil or all
        # -> no additional scope :)
      end
    }
  end

end
