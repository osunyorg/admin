/* global */
window.osuny.hideOnChange = {
    init: function () {
        'use strict';
        var element,
            i;
        this.elements = document.querySelectorAll('[data-hide-on-change]');
        for (i = 0; i < this.elements.length; i += 1) {
            element = this.elements[i];
            this.bind(element);
        }
    },

    bind: function (element) {
        'use strict';
        var container = document.getElementById(element.getAttribute('data-hide-on-change'));
        if (!container) {
            return;
        }
        container.addEventListener('input', this.hide.bind(this, element));
        container.addEventListener('change', this.hide.bind(this, element));
    },

    // If any field in the container has changed, hide the element
    hide: function (element) {
        'use strict';
        element.classList.add('d-none');
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke().init();
