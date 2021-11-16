window.osuny.communication.menuItems = {
    init: function () {
        'use strict';
        this.kindInput = document.querySelector('form #communication_website_menu_item_kind');
        if (this.kindInput === null) {
            return;
        }

        this.elementsForKindUrl = document.querySelectorAll('.kind-url');
        this.requiredInputsForKindUrl = document.querySelectorAll('.kind-url .required select, .kind-url .required input');

        this.elementsForKindPage = document.querySelectorAll('.kind-page');
        this.requiredInputsForKindPage = document.querySelectorAll('.kind-page .required select, .kind-page .required input');

        this.kindInput.addEventListener('change', this.onKindChange.bind(this));
        this.onKindChange();
    },

    onKindChange: function () {
        'use strict';
        var kind = this.kindInput.value;

        if (kind === 'url') {
            this.showElements(this.elementsForKindUrl, this.requiredInputsForKindUrl);
            this.hideElements(this.elementsForKindPage, this.requiredInputsForKindPage);
        } else if (kind === 'page') {
            this.showElements(this.elementsForKindPage, this.requiredInputsForKindPage);
            this.hideElements(this.elementsForKindUrl, this.requiredInputsForKindUrl);
        } else if (kind === 'blank') {
            this.hideElements(this.elementsForKindPage, this.requiredInputsForKindPage);
            this.hideElements(this.elementsForKindUrl, this.requiredInputsForKindUrl);
        }
    },

    showElements: function (elements, requiredInputs) {
        'use strict';
        var i;
        for (i = 0; i < elements.length; i += 1) {
            elements[i].classList.remove('d-none');
        }
        for (i = 0; i < requiredInputs.length; i += 1) {
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
    if (document.body.classList.contains('items-new') || document.body.classList.contains('items-edit')) {
        window.osuny.communication.menuItems.init();
    }
});
