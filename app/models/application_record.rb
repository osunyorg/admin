class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO put that in summernote-rails

  # https://github.com/rails/rails/blob/b961af3345fe2f9e492ba1e5424c2ceb75ac6ead/actiontext/lib/action_text/attribute.rb#L4
  def self.has_summernote(name)
    class_eval <<-CODE, __FILE__, __LINE__ + 1
      def #{name}
        # TODO hydrate action-text-attachment
        attributes['#{name}'].gsub('</action', 'coucou</action')
      end

      def #{name}=(value)
        # TODO dehydrate action-text-attachment
        attributes['#{name}'] = value
      end
    CODE
  end

  # TODO Remove everything below after migration, please

  def self.summernote(*args)
    @@summernote_fields = args
  end

  before_validation :summernote

  def summernote
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
