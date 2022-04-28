module Filters
  class Admin::Education::Schools < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
