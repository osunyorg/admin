import { createI18n } from 'vue-i18n';

// Messages are precompiled at boot into public/vue/<locale>.json (cf.
// config/initializers/vue_i18n.rb) and fetched once as a cacheable static
// file. getI18n() memoizes the fetch + instance so every Vue app/instance
// (including ones created later, e.g. Editor.vue's inner app) shares it.
let i18nPromise = null;

export function getI18n() {
  if (!i18nPromise) {
    i18nPromise = (async () => {
      const locale = document.documentElement.lang || 'fr';
      const messages = await fetch(`/vue/${locale}.json`)
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
