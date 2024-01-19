window.osuny.communication.websites.langSwitch = {
    init: function () {
        'use strict';
        this.select = document.querySelector('#js-website-lang-switch');
        if (this.select) {
            this.select.addEventListener('change', this.onChange.bind(this));
        }
    },

    onChange: function () {
        'use strict';
        document.location.href = this.select.selectedOptions[0].value;
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
    window.osuny.communication.websites.langSwitch.init();
});
