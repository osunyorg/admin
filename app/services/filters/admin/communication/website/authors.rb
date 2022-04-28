module Filters
  class Admin::Communication::Website::Authors < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
