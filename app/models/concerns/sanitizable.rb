module Sanitizable
  extend ActiveSupport::Concern

  included do

    before_validation :sanitize_fields

    def sanitize_fields
      attributes_to_sanitize.each do |attribute_name, attribute_type|
        dangerous_value = public_send attribute_name
        sanitized_value = Osuny::Sanitizer.sanitize(dangerous_value, attribute_type)
        public_send "#{attribute_name}=", sanitized_value
      end
    end

    protected

    #  {
    #   "description" => :text
    #  }
    def attributes_to_sanitize
      attributes_with_type.select { |attribute_name, attribute_type|
        should_sanitize?(attribute_name, attribute_type)
      }
    end

    def should_sanitize?(attribute_name, attribute_type)
      # We filter the attributes with "string" or "text" SQL type.
      return false unless [:string, :text].include?(attribute_type)
      # We filter the text attributes by their presence.
      return false unless public_send(attribute_name).present?
      # We filter the attributes which end with "_type" (polymorphic attributes)
      return false if attribute_name.ends_with?('_type')
      true
    end

    #  {
    #   "id" => :uuid,
    #   "description" => :text,
    #   "position" => :integer,
    #   "target_type" => :string,
    #   "created_at" => :datetime,
    #   "updated_at" => :datetime,
    #   "target_id" => :uuid,
    #   "university_id" => :uuid
    #  }
    def attributes_with_type
      self.class.columns_hash.map { |name, value| [name, value.type] }.to_h
    end
  end
end
