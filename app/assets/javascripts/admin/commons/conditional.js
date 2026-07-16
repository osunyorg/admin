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
            i,
            target;
        for (i = 0; i < allTargets.length; i += 1) {
            target = allTargets[i];
            if (this.matches(target, value)) {
                this.show(target);
            } else {
                this.hide(target);
            }
        }
    },

    // data-conditional-value="x": displayed only when value equals to x
    // data-conditional-value-not="x": displayed when value different from x
    matches: function (target, value) {
        'use strict';
        if (target.hasAttribute('data-conditional-value-not')) {
            return target.getAttribute('data-conditional-value-not') !== value;
        }
        return target.getAttribute('data-conditional-value') === value;
    },

    hide: function (target) {
        'use strict';
        var input = target.querySelector('select, input, textarea');
        target.classList.add('d-none');
        if (input) {
            input.removeAttribute('required');
            input.setAttribute('disabled', 'disabled');
        }
    },

    show: function (target) {
        'use strict';
        var input = target.querySelector('select, input, textarea'),
            optional = target.getAttribute('data-conditional-optional') === 'true';
        target.classList.remove('d-none');
        if (input) {
            input.removeAttribute('disabled');
            if (!optional) {
                input.setAttribute('required', 'required');
            }
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
