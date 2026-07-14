/* global */
window.osuny.dynamicPlaceholder = {
    init: function () {
        'use strict';
        var element,
            i;
        this.elements = document.querySelectorAll('[data-placeholder-source]');
        for (i = 0; i < this.elements.length; i += 1) {
            element = this.elements[i];
            this.bind(element);
        }
    },

    bind: function (element) {
        'use strict';
        var source = document.getElementById(element.getAttribute('data-placeholder-source'));
        if (!source) {
            return;
        }
        source.addEventListener('change', this.update.bind(this, element, source));
        this.update(element, source);
    },

    // data-placeholder-map='{"value-from-source": "placeholder to display", ...}'
    update: function (element, source) {
        'use strict';
        var map = JSON.parse(element.getAttribute('data-placeholder-map') || '{}'),
            value = map[this.getValue(source)];
        if (value) {
            element.setAttribute('placeholder', value);
        } else {
            element.removeAttribute('placeholder');
        }
    },

    getValue: function (element) {
        'use strict';
        if (element.type === 'checkbox') {
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
