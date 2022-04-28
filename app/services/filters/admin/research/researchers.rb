module Filters
  class Admin::Research::Researchers < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
