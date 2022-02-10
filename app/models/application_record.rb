class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # TODO put that in summernote-rails

  # https://github.com/rails/rails/blob/b961af3345fe2f9e492ba1e5424c2ceb75ac6ead/actiontext/lib/action_text/attribute.rb#L4
  # https://github.com/rails/rails/blob/b961af3345fe2f9e492ba1e5424c2ceb75ac6ead/actiontext/lib/action_text/content.rb#L121
  def self.has_summernote(name)
    class_eval <<-CODE, __FILE__, __LINE__ + 1
      serialize :#{name}, ActionText::Content
    CODE
  end
end
