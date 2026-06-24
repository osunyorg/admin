import { createApp } from 'vue';
import SsoMappingApp from './sso-mapping/SsoMappingApp.vue';
import MediaPickerApp from './media-picker/MediaPickerApp.vue';
import TimeSlotsApp from './time-slots/TimeSlotsApp.vue';
import BlocksEditorApp from './blocks-editor/BlocksEditorApp.vue';

if (document.getElementById('sso-mapping-app')) {
    createApp(SsoMappingApp).mount('#sso-mapping-app');
}
if (document.getElementById('media-picker-app')) {
    createApp(MediaPickerApp).mount('#media-picker-app');
}
if (document.getElementById('time-slots-app')) {
    createApp(TimeSlotsApp).mount('#time-slots-app');
}
if (document.getElementById('blocks-editor-app')) {
    createApp(BlocksEditorApp).mount('#blocks-editor-app');
}
