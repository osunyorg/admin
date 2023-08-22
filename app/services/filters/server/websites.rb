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
      add :for_update,
          [{ to_s: 'Automatique', id: 'true' }, { to_s: 'Manuelle', id: 'false' }],
          'Filtrer par mode de mise à jour'
    end
  end
end
