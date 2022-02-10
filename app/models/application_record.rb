class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Remove everything below after migration, please

  def self.summernote(*args)
    @@summernote_fields = args
  end

  before_validation :summernote

  def summernote
    @@summernote_fields.each do |field|
      self["#{field}_new"] = send(field).to_s
                                        .gsub('<div>', '<p>')
                                        .gsub('</div>', '</p>')
                                        .gsub('<p><br></p>', '')
    end
  end
end
