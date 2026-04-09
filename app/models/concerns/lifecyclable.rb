module Lifecyclable
  extend ActiveSupport::Concern

  LIFECYCLE_DAYS_BEFORE_DELETION = 30

  LIFECYCLE_ALL = 'all'
  LIFECYCLE_TEMPLATE = 'template'
  LIFECYCLE_PUBLISHED = 'published'
  LIFECYCLE_PLANNED = 'planned'
  LIFECYCLE_DRAFT = 'draft'
  LIFECYCLE_TRASH = 'trash'

  LIFECYCLE_STATUSES = [
    LIFECYCLE_ALL,
    LIFECYCLE_TEMPLATE,
    LIFECYCLE_PUBLISHED,
    LIFECYCLE_PLANNED,
    LIFECYCLE_DRAFT,
    LIFECYCLE_TRASH
  ]
  
  included do

    scope :at_lifecycle, -> (status, language) {
      if respond_to?(:templates)
        at_lifecycle_with_templates(status, language)
      else
        at_lifecycle_without_templates(status, language)
      end
    }

    scope :at_lifecycle_without_templates, -> (status, language) {
      case status
      when LIFECYCLE_PUBLISHED
        published_now_in(language)
      when LIFECYCLE_TEMPLATE
        none
      when LIFECYCLE_PLANNED
        published_in_the_future_in(language)
      when LIFECYCLE_DRAFT
        draft_in(language)
      when LIFECYCLE_TRASH
        only_deleted
      else
        # Status nil or all
        # -> no additional scope :)
      end
    }

    scope :at_lifecycle_with_templates, -> (status, language) {
      case status
      when LIFECYCLE_PUBLISHED
        except_templates.published_now_in(language)
      when LIFECYCLE_TEMPLATE
        templates
      when LIFECYCLE_PLANNED
        except_templates.published_in_the_future_in(language)
      when LIFECYCLE_DRAFT
        except_templates.draft_in(language)
      when LIFECYCLE_TRASH
        only_deleted
      else
        except_templates
      end
    }
  end

end
