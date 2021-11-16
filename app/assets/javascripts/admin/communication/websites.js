window.osuny.communication.websites = {
    init: function () {
        'use strict';
        this.aboutTypeInput = document.querySelector('form #communication_website_about_type');
        if (this.aboutTypeInput === null) {
            return;
        }

        this.elementsForTypeSchool = document.querySelectorAll('.type-school');
        this.requiredInputsForTypeSchool = document.querySelectorAll('.type-school .required select, .type-school .required input');

        this.elementsForTypeJournal = document.querySelectorAll('.type-journal');
        this.requiredInputsForTypeJournal = document.querySelectorAll('.type-journal .required select, .type-journal .required input');

        this.aboutTypeInput.addEventListener('change', this.onTypeChange.bind(this));
        this.onTypeChange();
    },

    onTypeChange: function () {
        'use strict';
        var aboutType = this.aboutTypeInput.value;

        if (aboutType === 'Education::School') {
            this.showElements(this.elementsForTypeSchool, this.requiredInputsForTypeSchool);
            this.hideElements(this.elementsForTypeJournal, this.requiredInputsForTypeJournal);
        } else if (aboutType === 'Research::Journal') {
            this.showElements(this.elementsForTypeJournal, this.requiredInputsForTypeJournal);
            this.hideElements(this.elementsForTypeSchool, this.requiredInputsForTypeSchool);
        } else {
            this.hideElements(this.elementsForTypeJournal, this.requiredInputsForTypeJournal);
            this.hideElements(this.elementsForTypeSchool, this.requiredInputsForTypeSchool);
        }
    },

    showElements: function (elements, requiredInputs) {
        'use strict';
        var i;
        for (i = 0; i < elements.length; i += 1) {
            elements[i].classList.remove('d-none');
        }
        for (i = 0; i < requiredInputs.length; i += 1) {
            requiredInputs[i].removeAttribute('disabled');
            requiredInputs[i].setAttribute('required', 'required');
        }
    },

    hideElements: function (elements, requiredInputs) {
        'use strict';
        var i;
        for (i = 0; i < elements.length; i += 1) {
            elements[i].classList.add('d-none');
        }
        for (i = 0; i < requiredInputs.length; i += 1) {
            requiredInputs[i].removeAttribute('required');
            requiredInputs[i].setAttribute('disabled', 'disabled');
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
    if (document.body.classList.contains('websites-new') || document.body.classList.contains('websites-edit')) {
        window.osuny.communication.websites.init();
    }
});
