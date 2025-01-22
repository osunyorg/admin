import { createApp } from 'vue';
import SsoMappingApp from './sso-mapping/SsoMappingApp.vue';
import Media::PickerApp from './media-picker/Media::PickerApp.vue';

if (document.getElementById('sso-mapping-app')) {
    createApp(SsoMappingApp).mount('#sso-mapping-app');
}
if (document.getElementById('media-picker-app')) {
    createApp(Media::PickerApp).mount('#media-picker-app');
}
