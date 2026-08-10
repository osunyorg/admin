module Sortable
  extend ActiveSupport::Concern

  class_methods do

    # key: alpha, date_desc...
    def autosort(key, language)
      return self if key.blank?
      # autosort_by_alpha
      scope_identifier = "autosort_by_#{key}"
      # apply scope
      public_send(scope_identifier, language)
    end
  end
end