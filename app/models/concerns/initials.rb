module Initials
  extend ActiveSupport::Concern

  def initials
    to_s.first
  end

end
