window.osuny.sso = {
    init: function () {
        'use strict';
        this.hasSsoInput = document.querySelector('input[type="checkbox"][name$="[has_sso]"]');
        this.hasSsoInput.addEventListener('change', this.onHasSsoChange.bind(this));
        this.ssoFields = document.querySelectorAll('.sso-inputs');
        this.onHasSsoChange();
    },

    onHasSsoChange: function () {
        'use strict';
        var value = this.hasSsoInput.checked,
            i;
        for (i = 0; i < this.ssoFields.length; i += 1) {
            if (value) {
                this.ssoFields[i].classList.remove('d-none');
            } else {
                this.ssoFields[i].classList.add('d-none');
            }
        }
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
    if (document.querySelector('[name$="[has_sso]"]')) {
        window.osuny.sso.init();
    }
});
