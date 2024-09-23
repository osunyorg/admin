module Importers
  class Organizations < Base

    protected

    def analyze_hash(hash, index)
      hash_to_organization = HashToOrganization.new(@university, @language, hash)
      add_error(hash_to_organization.error, index + 1) unless hash_to_organization.valid?
    end

  end
end
