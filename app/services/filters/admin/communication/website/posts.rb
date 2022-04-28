module Filters
  class Admin::Communication::Website::Posts < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
