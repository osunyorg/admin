module Filters
  class Base
    attr_accessor :list

    def initialize(user)
      @user = user
      @list = []
    end

    protected

    def add(scope_name, choices, label, multiple = false)
      @list << {
        scope_name: scope_name,
        choices: choices,
        label: label,
        multiple: multiple
      }
    end

    def add_if(condition, args)
      add *args if condition
    end

    def add_search
      add :for_search_term, nil, I18n.t('search')
    end

    def add_date_filter(objects, attribute)
      dates = objects.map { |obj|
        {
          to_s: I18n.l(obj[attribute], format: "%B %Y"),
          id: I18n.l(obj[attribute], format: "%Y-%m")
        }
      }.uniq
      add :for_date, dates, t('filters.attributes.date')
    end
  end
end
