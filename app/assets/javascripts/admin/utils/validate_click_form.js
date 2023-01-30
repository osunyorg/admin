/* global $ */
window.osuny.validateFromClickManager = {
    init: function () {
        'use strict';

        this.elements = document.querySelectorAll('.js-validate-form-click');
        
        if (this.elements.length > 0) {
            this.listen();
        }
    },

    listen: function() {
        'use strict';

        this.elements.forEach(function(element) {
            this.bindClick(element)
        }.bind(this));
    },

    bindClick: function(element) {
        'use strict';
        var form = element.querySelector('form');

        if (!form) {
            return;
        }

        element.style.cursor = "pointer"
        element.addEventListener('click', function() {
            form.submit();
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
    window.osuny.validateFromClickManager.init();
});
