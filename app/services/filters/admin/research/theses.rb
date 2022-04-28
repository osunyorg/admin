module Filters
  class Admin::Research::Theses < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
