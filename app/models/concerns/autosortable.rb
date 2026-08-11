module Autosortable
  extend ActiveSupport::Concern

  class_methods do

    # key: alpha, date_desc...
    def autosort(key, language)
      return all if key.blank?
      # autosort_by_alpha
      scope_identifier = "autosort_by_#{key}"
      # apply scope
      if respond_to?(scope_identifier)
        public_send(scope_identifier, language)
      else
        all
      end
    end
  end
end