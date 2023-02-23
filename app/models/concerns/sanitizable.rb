module Sanitizable
  extend ActiveSupport::Concern

  included do

    before_validation :sanitize_fields

    def sanitize_fields
      attributes_to_sanitize = self.class.columns_hash.map { |name,value| [name, value.type] }
                                                      .to_h
                                                      .select { |attr_name, attr_type|
                                                        [:string, :text].include?(attr_type) && public_send(attr_name).present?
                                                      }
                                                      .reject { |attr_name, _|
                                                        attr_name.ends_with?('_type') # Reject polymorphic type
                                                      }

      attributes_to_sanitize.each do |attr_name, attr_type|
        public_send "#{attr_name}=", Osuny::Sanitizer.sanitize(public_send(attr_name), attr_type)
      end
    end

  end
end
