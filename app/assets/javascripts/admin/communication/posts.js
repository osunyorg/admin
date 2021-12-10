window.osuny.communication.posts = {
    init: function () {
        'use strict';
        var i;

        this.fieldset = document.querySelector('form fieldset.communication_website_post_categories');
        if (this.fieldset === null) {
            return;
        }

        this.checkboxes = this.fieldset.querySelectorAll('input[type="checkbox"]');
        for (i = 0; i < this.checkboxes.length; i += 1) {
            this.checkboxes[i].addEventListener('change', this.onCheckboxChange.bind(this));
        }
    },

    onCheckboxChange: function (event) {
        'use strict';
        var checkbox = event.currentTarget,
            parentId = checkbox.dataset.parent,
            parentCheckbox;

        if (!checkbox.checked || typeof parentId === 'undefined') {
            return;
        }

        parentCheckbox = this.fieldset.querySelector('input[type="checkbox"][value="' + parentId + '"]');
        if (parentCheckbox !== null) {
            this.triggerCheck(parentCheckbox);
        }
    },

    triggerCheck: function (checkbox) {
        'use strict';
        var evt;
        checkbox.checked = true;
        if (typeof document.createEvent !== 'undefined') {
            evt = document.createEvent('HTMLEvents');
            evt.initEvent('change', false, true);
            checkbox.dispatchEvent(evt);
        } else {
            checkbox.fireEvent('onchange');
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
    if (document.body.classList.contains('posts-new') || document.body.classList.contains('posts-edit')) {
        window.osuny.communication.posts.init();
    }
});
