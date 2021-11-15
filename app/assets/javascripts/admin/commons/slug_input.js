/*global $ */
window.osuny.slugInput = {
    init: function () {
        'use strict';
        var sourceInput,
            slugInput,
            i;
        this.slugInputs = document.querySelectorAll('.js-slug-input');

        if (this.slugInputs.length === 0) {
            return;
        }

        for (i = 0; i < this.slugInputs.length; i += 1) {
            this.initInput(this.slugInputs[i]);
        }
    },

    initInput: function (input) {
        'use strict';
        var sourceSelectors = input.dataset.source.split(','),
            sourceInputs = [],
            sourceInput,
            i;

        for (i = 0; i < sourceSelectors.length; i += 1) {
            sourceInput = document.querySelector(sourceSelectors[i].trim());
            if (sourceInput !== null) {
                sourceInputs.push(sourceInput);
            }
        }

        for (i = 0; i < sourceInputs.length; i += 1) {
            sourceInputs[i].addEventListener('input', this.onSourceChange.bind(this, sourceInputs, input));
        }
    },

    onSourceChange: function (sourceInputs, slugInput) {
        'use strict';
        var values = [],
            value,
            i;
        for (i = 0; i < sourceInputs.length; i += 1) {
            value = sourceInputs[i].value.trim();
            if (value !== '') {
                values.push(value);
            }
        }

        slugInput.value = window.slug(values.join(' '));
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
    window.osuny.slugInput.init();
});
