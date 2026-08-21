import { createApp } from 'vue';
import { getI18n } from './i18n';
import BlocksEditorApp from './blocks-editor/BlocksEditorApp.vue';
import DownloadableSummaryApp from './downloadable-summary/DownloadableSummaryApp.vue';
import FeaturedMediaApp from './featured-media/FeaturedMediaApp.vue';
import PickerTestApp from './picker/PickerTestApp.vue';
import SsoMappingApp from './sso-mapping/SsoMappingApp.vue';
import TimeSlotsApp from './time-slots/TimeSlotsApp.vue';

async function boot() {
  const i18n = await getI18n();

  const mount = (App, selector) => {
    if (document.querySelector(selector)) {
      createApp(App).use(i18n).mount(selector);
    }
  };

  mount(BlocksEditorApp, '#blocks-editor-app');
  mount(DownloadableSummaryApp, '#downloadable-summary-app');
  mount(FeaturedMediaApp, '#featured-media-app');
  mount(PickerTestApp, '#picker-test-app');
  mount(SsoMappingApp, '#sso-mapping-app');
  mount(TimeSlotsApp, '#time-slots-app');
}

boot();
