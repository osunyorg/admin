module Filters
  class Admin::University::Person::Alumni < Filters::Base
    def initialize(user)
      super
      add_search
    end
  end
end
