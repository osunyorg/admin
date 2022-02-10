class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO put that in summernote-rails

  has_many_attached :summernote_embeds

  before_save :update_summernote_embeds

  def update_summernote_embeds
    attributes_using_summernote = self.class.attribute_names_using_summernote.map { |attribute_name|
      public_send(attribute_name)
    }.compact

    self.summernote_embeds = attributes_using_summernote.map { |attribute|
      attribute.attachables.grep(ActiveStorage::Blob).uniq
    }.flatten if attributes_using_summernote.any?
  end

  def self.attribute_names_using_summernote
    @@attribute_names_using_summernote ||= attribute_names.select { |attribute_name|
      attribute_type = type_for_attribute(attribute_name)
      attribute_type.is_a?(ActiveRecord::Type::Serialized) && attribute_type.coder == ActionText::Content
    }
  end

  # https://github.com/rails/rails/blob/b961af3345fe2f9e492ba1e5424c2ceb75ac6ead/actiontext/lib/action_text/attribute.rb#L4
  # https://github.com/rails/rails/blob/b961af3345fe2f9e492ba1e5424c2ceb75ac6ead/actiontext/lib/action_text/content.rb#L121
  def self.has_summernote(name)
    class_eval <<-CODE, __FILE__, __LINE__ + 1
      serialize :#{name}, ActionText::Content
    CODE
  end
end
