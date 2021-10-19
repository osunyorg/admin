/*global Notyf */
var notyfAlerts = document.getElementsByClassName('js-notyf-alert'),
    notyfNotices = document.getElementsByClassName('js-notyf-notice'),
    notyf = new Notyf();

if (notyfAlerts.length > 0) {
    notyf.open({
        type: 'error',
        position: {
            x: 'right',
            y: 'top'
        },
        message: notyfAlerts[0].innerText,
        duration: 9000,
        ripple: true,
        dismissible: true
    });
}
if (notyfNotices.length > 0) {
    notyf.open({
        type: 'success',
        position: {
            x: 'right',
            y: 'top'
        },
        message: notyfNotices[0].innerText,
        duration: 9000,
        ripple: true,
        dismissible: true
    });
}
