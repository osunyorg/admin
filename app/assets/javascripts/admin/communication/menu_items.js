/* global $ */
window.osuny.communication.menuItems = {
    init: function () {
        'use strict';
        var i,
            kind;
        this.kindInput = document.getElementById('communication_website_menu_item_kind');
        this.kinds = document.querySelectorAll('[data-kind]');
        this.url = document.querySelector('.communication_website_menu_item_url');
        this.switchUrl = this.kindInput.dataset.url;
        for (i = 0; i < this.kinds.length; i += 1) {
            kind = this.kinds[i];
            kind.addEventListener('click', this.onKindChange.bind(this));
        }
        this.chooseKind(this.kindInput.value);
    },

    onKindChange: function (event) {
        'use strict';
        var target = event.target,
            // TODO get value from parent class="kind"
            kind = target.dataset.tmp;
        this.chooseKind(kind);
        this.loadData(kind);
    },

    chooseKind: function (kind) {
        'use strict';
        var active = document.querySelector('[data-kind="' + kind + '"]'),
            i;
        this.kindInput.value = kind;
        for (i = 0; i < this.kinds.length; i += 1) {
            this.kinds[i].classList.remove('kind--selected');
        }
        active.classList.add('kind--selected');
        if (kind === 'url') {
            this.url.classList.remove('d-none');
        } else {
            this.url.classList.add('d-none');
        }
    },

    loadData: function (kind) {
        'use strict';
        $.ajax(this.switchUrl, {
            method: 'GET',
            data: 'kind=' + kind,
            processData: false,
            contentType: false
        });
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
