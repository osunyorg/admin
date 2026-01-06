module Osuny::Api
  class MigrationIdentifierIntegrityChecker
    
    attr_reader :resource, :params, :list

    def initialize(resource, params, list)
      @resource = resource
      @params = params
      @list = list
    end

    def migration_identifier
      @migration_identifier ||= params.dig(:migration_identifier)
    end

    def empty?
      migration_identifier.blank?
    end

    def different?
      raise 'Missing resource' if resource.nil?
      resource.migration_identifier != migration_identifier
    end

    def already_used?
      raise 'Missing migration_identifier' if empty?
      list.where(migration_identifier: migration_identifier).exists?
    end
  end
end