module Filters
  class Admin::Research::Journals < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
