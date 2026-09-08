module Autosortable
  extend ActiveSupport::Concern

  class_methods do

    # key: alpha, date_desc...
    def autosort(key, language)
      # On ne trie pas s'il n'y a pas de clé de tri
      return all if key.blank?
      # Ex: autosort_by_alpha
      scope_identifier = "autosort_by_#{key}"
      # Application du tri si le scope existe
      if respond_to?(scope_identifier)
        public_send(scope_identifier, language)
      else
        all
      end
    end
  end
end