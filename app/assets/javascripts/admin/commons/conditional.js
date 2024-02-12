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
            this.update(element.id, this.getValue(element));
        }
    },

    change: function (event) {
        'use strict';
        this.update(event.target.id, this.getValue(event.target));
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
        if (input) {
            input.removeAttribute('required');
            input.setAttribute('disabled', 'disabled');
        }
    },

    show: function (target) {
        'use strict';
        var input = target.querySelector('select');
        target.classList.remove('d-none');
        if (input) {
            input.removeAttribute('disabled');
            input.setAttribute('required', 'required');
        }
    },

    getValue: function (element) {
        'use strict';
        if (element.type == 'checkbox') {
            return element.checked;
        } else {
            return element.value;
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke().init();
