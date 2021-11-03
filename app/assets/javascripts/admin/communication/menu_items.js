window.osuny.communication.menuItems = {
    init: function () {
        'use strict';
        this.kindInput = document.querySelector('form #communication_website_menu_item_kind');
        if (this.kindInput === null) {
            return;
        }

        this.elementsForKindUrl = document.querySelectorAll('.kind-url');
        this.requiredInputsForKindUrl = document.querySelectorAll('.kind-url .form-group.required select, .kind-url .form-group.required input');

        this.kindInput.addEventListener('change', this.onKindChange.bind(this));
        this.onKindChange();
    },

    onKindChange: function () {
        'use strict';
        var kind = this.kindInput.value,
            i;
        for (i = 0; i < this.elementsForKindUrl.length; i += 1) {
            if (kind === 'url') {
                this.elementsForKindUrl[i].classList.remove('d-none');
            } else {
                this.elementsForKindUrl[i].classList.add('d-none');
            }
        }
        for (i = 0; i < this.requiredInputsForKindUrl.length; i += 1) {
            if (kind === 'url') {
                this.requiredInputsForKindUrl[i].setAttribute('required', 'required');
            } else {
                this.requiredInputsForKindUrl[i].removeAttribute('required');
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
    if (document.body.classList.contains('items-new') || document.body.classList.contains('items-edit')) {
        window.osuny.communication.menuItems.init();
    }
});
