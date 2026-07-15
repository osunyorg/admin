# Génère les fichiers de traduction statiques des apps Vue dans
# public/vue/<locale>.json. Ils servent de messages à vue-i18n (cf.
# app/javascript/apps/index.js) et sont chargés une seule fois, en statique
# cacheable, plutôt que sérialisés dans chaque page.
#
# after_initialize garantit que tous les config/locales/**/*.yml sont bien
# ajoutés à I18n.load_path. En dev, redémarrer le serveur régénère les fichiers
# après modification d'une traduction.
Rails.application.config.after_initialize do
  output_dir = Rails.root.join('public', 'vue')
  FileUtils.mkdir_p(output_dir)
  I18n.available_locales.each do |locale|
    translations = I18n.t('vue', locale: locale, default: {})
    File.write(output_dir.join("#{locale}.json"), translations.to_json)
  end
end
