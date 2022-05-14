module Filters
  class Admin::Education::Programs < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
