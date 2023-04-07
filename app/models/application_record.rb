class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def website_direct_object?
    respond_to? :website
  end

  def website_indirect_object?
    !website_direct_object?
  end
end
