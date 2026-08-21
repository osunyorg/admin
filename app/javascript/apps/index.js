import { createApp } from 'vue';
import { getI18n } from './i18n';
import SsoMappingApp from './sso-mapping/SsoMappingApp.vue';
import MediaPickerApp from './media-picker/MediaPickerApp.vue';
import TimeSlotsApp from './time-slots/TimeSlotsApp.vue';
import BlocksEditorApp from './blocks-editor/BlocksEditorApp.vue';
import PickerTestApp from './picker/PickerTestApp.vue';

async function boot() {
  const i18n = await getI18n();

  const mount = (App, selector) => {
    if (document.querySelector(selector)) {
      createApp(App).use(i18n).mount(selector);
    }
  };

  mount(SsoMappingApp, '#sso-mapping-app');
  mount(MediaPickerApp, '#media-picker-app');
  mount(TimeSlotsApp, '#time-slots-app');
  mount(BlocksEditorApp, '#blocks-editor-app');
  mount(PickerTestApp, '#picker-test-app');
}

boot();
