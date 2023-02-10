module Filters
  class Server::Websites < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_theme_version,
          ::Communication::Website.all.pluck(:theme_version).uniq.sort,
          'Filtrer par version du thème'
    end
  end
end
