/* global $ */
window.osuny.communication.menuItems = {
    init: function () {
        'use strict';
        this.kindInput = document.querySelector('form .js-kind-input');
        if (this.kindInput === null) {
            return;
        }

        this.switchUrl = this.kindInput.dataset.url;

        this.kindInput.addEventListener('change', this.onKindChange.bind(this));
        this.onKindChange();
    },

    onKindChange: function () {
        'use strict';
        var kind = this.kindInput.value;

        $.ajax(this.switchUrl, {
            method: 'GET',
            data: 'kind=' + kind,
            processData: false,
            contentType: false
        });
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    if (document.body.classList.contains('items-new') || document.body.classList.contains('items-edit')) {
        window.osuny.communication.menuItems.init();
    }
});
