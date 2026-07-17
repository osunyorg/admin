import { createI18n } from 'vue-i18n';

// Les locales sont transformées en fichier JSON dans :
// app/assets/builds/vue/<locale>.json
// La transformation se fait dans :
// config/initializers/vue_i18n.rb
// Les fichiers JSON passent ensuite par Sprockets pour gérer le cache correctement.
// Le chemin des fichiers est passé en data-attribute :
// <html data-vue-i18n-path="/assets/vue/fr-8fe2c104baca4af3181348aafbd2e7877701c6f684d62f090f41597aa7b0d78a.json">
let i18nPromise = null;

export function getI18n() {
  if (!i18nPromise) {
    i18nPromise = (async () => {
      const locale = document.documentElement.lang || 'fr';
      const path = document.documentElement.dataset.vueI18nPath;
      const messages = await fetch(path)
        .then((res) => res.json())
        .catch(() => ({}));
      return createI18n({
        legacy: false,
        globalInjection: true,
        locale,
        fallbackLocale: 'fr',
        messages: { [locale]: messages },
      });
    })();
  }
  return i18nPromise;
}
