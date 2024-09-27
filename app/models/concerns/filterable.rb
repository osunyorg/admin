# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  included do
    class_attribute :scope_names, instance_accessor: true, default: []
  end

  class_methods do
    def scope(name, body, &block)
      scope_names << name.to_s
      super
    end

    def filter_by(params, language)
      return all unless params
      params.to_unsafe_hash.reduce(all) do |scope, (name, value)|
        value = value.strip if value.is_a?(String)
        # params might contain an array with an empty value [""] if it has been reset by select2
        value.compact_blank! if value.is_a?(Array)
        if scope_names.include?(name) && value.present?
          scope.public_send(name, value, language)
        else
          scope
        end
      end
    end
  end
end