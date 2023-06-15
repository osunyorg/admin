window.osuny.communication.websites = {
    init: function () {
        'use strict';
        this.languagesCheckboxes = document.querySelectorAll('.js-languages input[type="checkbox"]');
        this.defaultLanguageSelect = document.querySelector('.js-default-language');
        if (this.defaultLanguageSelect) {
            this.defaultLanguageOptions = this.defaultLanguageSelect.querySelectorAll('option');
            this.initEvents();
            this.onChangeCheckbox();
        }
    },

    initEvents: function () {
        'use strict';
        var i;
        for (i = 0; i < this.languagesCheckboxes.length; i += 1) {
            this.languagesCheckboxes[i].addEventListener('change', this.onChangeCheckbox.bind(this));
        }
    },

    onChangeCheckbox: function () {
        'use strict';
        var languageCheckbox,
            languageOption,
            i;

        // Clean options
        this.defaultLanguageSelect.innerHTML = '';

        // Re-hydrate options
        for (i = 0; i < this.defaultLanguageOptions.length; i += 1) {
            languageOption = this.defaultLanguageOptions[i];
            languageCheckbox = document.querySelector('.js-languages input[type="checkbox"][value="' + languageOption.value + '"]');
            if (languageOption.value === '' || languageCheckbox.checked) {
                this.defaultLanguageSelect.appendChild(languageOption);
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
    if (window.osuny.isInControllerForm('websites')) {
        window.osuny.communication.websites.init();
    }
});
