window.osuny.sso = {
    init: function () {
        'use strict';
        this.hasSsoInput = document.querySelector('input[type="checkbox"][name$="[has_sso]"]');
        this.hasSsoInput.addEventListener('change', this.onHasSsoChange.bind(this));
        this.ssoFields = document.querySelectorAll('.sso-inputs');
        this.onHasSsoChange();

        this.hasInheritedSsoInput = document.querySelector('input[type="checkbox"][name$="[sso_inherit_from_university]"]');
        if (this.hasInheritedSsoInput) {
            this.hasInheritedSsoInput.addEventListener('change', this.onHasInheritedSsoChange.bind(this));
            this.ssoInheritedFields = document.querySelectorAll('.sso-inherited-inputs');
            this.onHasInheritedSsoChange();
        }
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

    onHasInheritedSsoChange: function () {
        'use strict';
        var value = this.hasInheritedSsoInput.checked,
            i;
        for (i = 0; i < this.ssoInheritedFields.length; i += 1) {
            if (value) {
                this.ssoInheritedFields[i].classList.add('d-none');
            } else {
                this.ssoInheritedFields[i].classList.remove('d-none');
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
