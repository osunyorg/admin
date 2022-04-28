module Filters
  class Admin::Research::Laboratories < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
