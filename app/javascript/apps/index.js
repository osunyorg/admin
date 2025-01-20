import { createApp } from 'vue';
import SsoMappingApp from './SsoMappingApp.vue';
import MediaPickerApp from './media-picker/App.vue';

if (document.getElementById('sso-mapping-app')) {
    createApp(SsoMappingApp).mount('#sso-mapping-app');
}

if (document.getElementById('media-picker-app')) {
    createApp(MediaPickerApp).mount('#media-picker-app');
}
