window.osuny.communication.websites.pages.form = {
    init: function () {
        'use strict';
        this.headerCtaInput = document.querySelector('input[type="checkbox"][name$="[header_cta]"]');
        if (this.headerCtaInput) {
            this.headerCtaInput.addEventListener('change', this.onHeaderCtaChange.bind(this));
            this.headerCtaFields = document.querySelectorAll('.js-header-cta-fields');
            this.onHeaderCtaChange();
        }
    },

    onHeaderCtaChange: function () {
        'use strict';
        var value = this.headerCtaInput.checked,
        i;
        for (i = 0; i < this.headerCtaFields.length; i += 1) {
            if (value) {
                this.headerCtaFields[i].classList.remove('d-none');
            } else {
                this.headerCtaFields[i].classList.add('d-none');
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
    if (window.osuny.isInControllerForm('pages')) {
        window.osuny.communication.websites.pages.form.init();
    }
});
