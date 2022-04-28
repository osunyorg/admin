module Filters
  class Admin::Education::Teachers < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
