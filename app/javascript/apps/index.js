import { createApp } from 'vue';
import SsoMappingApp from './SsoMappingApp.vue';

if (document.getElementById('sso-mapping-app')) {
    createApp(SsoMappingApp).mount('#sso-mapping-app');
}
