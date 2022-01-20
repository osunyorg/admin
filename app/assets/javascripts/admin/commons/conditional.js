/* global */
window.osuny.conditional = {
    init: function () {
        'use strict';
        var element,
            i;
        this.elements = document.querySelectorAll('[data-conditional="true"]');
        for (i = 0; i < this.elements.length; i += 1) {
            element = this.elements[i];
            element.addEventListener('change', this.change.bind(this));
            this.update(element.id, element.value);
        }
    },

    change: function (event) {
        'use strict';
        this.update(event.target.id, event.target.value);
    },

    update: function (source, value) {
        'use strict';
        var allTargets = document.querySelectorAll('[data-conditional-source="' + source + '"]'),
            activeTargets = document.querySelectorAll('[data-conditional-source="' + source + '"][data-conditional-value="' + value + '"]'),
            i,
            target;
        for (i = 0; i < allTargets.length; i += 1) {
            target = allTargets[i];
            this.hide(target);
        }
        for (i = 0; i < activeTargets.length; i += 1) {
            target = activeTargets[i];
            this.show(target);
        }
    },

    hide: function (target) {
        'use strict';
        var input = target.querySelector('select');
        target.classList.add('d-none');
        input.removeAttribute('required');
        input.setAttribute('disabled', 'disabled');
    },

    show: function (target) {
        'use strict';
        var input = target.querySelector('select');
        target.classList.remove('d-none');
        input.removeAttribute('disabled');
        input.setAttribute('required', 'required');
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke().init();
