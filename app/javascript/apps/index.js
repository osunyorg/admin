import { createApp } from 'vue';
import { createI18n } from 'vue-i18n';
import SsoMappingApp from './sso-mapping/SsoMappingApp.vue';
import MediaPickerApp from './media-picker/MediaPickerApp.vue';
import TimeSlotsApp from './time-slots/TimeSlotsApp.vue';
import BlocksEditorApp from './blocks-editor/BlocksEditorApp.vue';

// Messages are precompiled at boot into public/vue/<locale>.json (cf.
// config/initializers/vue_i18n.rb) and fetched once as a cacheable static file,
// then shared by every app through a single vue-i18n instance.
async function boot() {
  const locale = document.documentElement.lang || 'fr';
  const messages = await fetch(`/vue/${locale}.json`)
    .then((res) => res.json())
    .catch(() => ({}));
  const i18n = createI18n({
    legacy: false,
    globalInjection: true,
    locale,
    fallbackLocale: 'fr',
    messages: { [locale]: messages },
  });

  const mount = (App, selector) => {
    if (document.querySelector(selector)) {
      createApp(App).use(i18n).mount(selector);
    }
  };

  mount(SsoMappingApp, '#sso-mapping-app');
  mount(MediaPickerApp, '#media-picker-app');
  mount(TimeSlotsApp, '#time-slots-app');
  mount(BlocksEditorApp, '#blocks-editor-app');
}

boot();
