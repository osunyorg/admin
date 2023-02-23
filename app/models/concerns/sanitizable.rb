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
      attribute_is_textual?(attribute_type) &&
        attribute_has_value?(attribute_name) &&
        attribute_is_not_polymorphic?(attribute_name)
    end

    def attribute_is_textual?(attribute_type)
      # We filter the attributes with "string" or "text" SQL type.
      [:string, :text].include?(attribute_type)
    end

    def attribute_has_value?(attribute_name)
      # We filter the text attributes by their presence.
      public_send(attribute_name).present?
    end

    def attribute_is_not_polymorphic?(attribute_name)
      # We filter the attributes which end with "_type" (polymorphic attributes)
      !attribute_name.ends_with?('_type')
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
