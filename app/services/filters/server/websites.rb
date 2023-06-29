module Filters
  class Server::Websites < Filters::Base
    def initialize(user)
      super
      add_search
      add :for_theme_version,
          ::Communication::Website.all.pluck(:theme_version).uniq.sort,
          'Filtrer par version du thème'
      add :for_production,
          [{ to_s: I18n.t('true'), id: 'true' }, { to_s: I18n.t('false'), id: 'false' }],
          'Filtrer par état de production'
    end
  end
end
