# Génère les messages de traduction des apps Vue dans app/assets/builds/vue/,
# aux côtés de vue-apps.js (cf. app/assets/config/manifest.js: link_tree
# ../builds). Sprockets les prend donc en charge comme n'importe quel asset :
# digest de cache-busting et far-future cache-control automatiques, servis via
# asset_path("vue/#{locale}.json") (cf. layout admin et app/javascript/apps/i18n.js).
#
Rails.application.config.after_initialize do
  # after_initialize garantit que tous les config/locales/**/*.yml sont bien
  # ajoutés à I18n.load_path, et s'exécute avant assets:precompile (jsbundling-rails
  # le fait dépendre de la tâche `environment`). En dev, redémarrer le serveur
  # régénère les fichiers après modification d'une traduction.
  output_dir = Rails.root.join('app', 'assets', 'builds', 'vue')
  FileUtils.mkdir_p(output_dir)
  I18n.available_locales.each do |locale|
    translations = I18n.t('vue', locale: locale, default: {})
    File.write(output_dir.join("#{locale}.json"), translations.to_json)
  end
end
