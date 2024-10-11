/* global $, Sortable */
window.osuny.contentEditor.sort = {
    init: function () {
        'use strict';
        this.container = document.querySelector('.js-content-editor');
        this.sortableContainers = this.container.querySelectorAll('.js-content-editor-sortable-container');
        this.sortUrl = this.container.getAttribute('data-sort-url');
        this.initSortable();
    },

    initSortable: function () {
        'use strict';
        var i;
        for (i = 0; i < this.sortableContainers.length; i += 1) {
            new Sortable(this.sortableContainers[i], {
                handle: '.content-editor__elements__handle',
                fallbackOnBody: false,
                onEnd: this.onSortableEnd.bind(this)
            });
        }
    },

    onSortableEnd: function (event) {
        'use strict';
        var ids = [],
            child,
            i;
        for (i = 0; i < event.to.children.length; i += 1) {
            child = event.to.children[i];
            ids.push({
                id: child.dataset.id,
                kind: child.dataset.kind
            });
        }
        $.post(this.sortUrl, { ids: ids });
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();
