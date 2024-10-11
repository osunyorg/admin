window.osuny = window.osuny || {};
window.osuny.contentEditor = {
    init: function () {
        'use strict';
        this.container = document.querySelector('.js-content-editor');
        if (this.container !== null) {
            window.osuny.contentEditor.offcanvas.init();
            window.osuny.contentEditor.tabs.init();
            window.osuny.contentEditor.sort.init();
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.contentEditor.init();
});
