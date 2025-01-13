import ssoMappingApp from './sso-mapping';

// Initialize the SsoMappingApp if the element is present
window.addEventListener('load', function () {
    const ssoMappingAppElement = document.getElementById('sso-mapping-app');
    if (ssoMappingAppElement) {
        setTimeout(function () {
            ssoMappingApp.mount(ssoMappingAppElement);
        }, 1000);
    }
});
