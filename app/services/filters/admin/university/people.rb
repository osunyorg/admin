module Filters
  class Admin::University::People < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
