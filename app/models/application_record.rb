class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO put that in summernote-rails

  # https://github.com/rails/rails/blob/b961af3345fe2f9e492ba1e5424c2ceb75ac6ead/actiontext/lib/action_text/attribute.rb#L4
  def self.has_summernote(name)
    class_eval <<-CODE, __FILE__, __LINE__ + 1
      def #{name}
        value = attributes['#{name}']
        actiontext = ActionText::Content.new value
        actiontext.to_s
      end

      def #{name}=(value)
        actiontext = ActionText::Content.new value
        self.attributes['#{name}'] = actiontext.to_html
      end
    CODE
  end

  # TODO Remove everything below after migration, please

  def self.convert_fields_to_summernote(*args)
    @@summernote_fields = args
  end

  # before_validation :convert_to_summernote

  def convert_to_summernote
    @@summernote_fields.each do |field|
      self["#{field}_new"] = send(field).body.to_html
                                        .gsub('<div>', '<p>')
                                        .gsub('</div>', '</p>')
                                        .gsub('<strong>', '<b>')
                                        .gsub('</strong>', '</b>')
                                        .gsub('<em>', '<i>')
                                        .gsub('</em>', '</i>')
                                        .gsub('<p><br></p>', '')
    end
  end
end
