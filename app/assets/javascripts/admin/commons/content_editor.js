/* global $, Sortable */
window.osuny = window.osuny || {};
window.osuny.contentEditor = {

    init: function () {
        'use strict';
        this.container = document.querySelector('.js-content-editor');
        if (this.container === null) {
            return;
        }
        this.sortHeadingsUrl = this.container.getAttribute('data-sort-headings-url');
        this.sortBlocksUrl = this.container.getAttribute('data-sort-blocks-url');

        this.initSortable();
    },

    initSortable: function () {
        'use strict';
        var sortableContainers = this.container.querySelectorAll('.js-content-editor-sortable-container'),
            i;

        for (i = 0; i < sortableContainers.length; i += 1) {
            new Sortable(sortableContainers[i], {
                handle: '.content-editor__elements__handle',
                fallbackOnBody: false,
                onEnd: this.onSortableEnd.bind(this)
            });
        }
    },

    onSortableEnd: function (event) {
        'use strict';
        var url,
            to = event.to,
            ids = [],
            headingId = null,
            child,
            i;
        if (event.from.classList.contains('content-editor--write')) {
            // Mode écriture du contenu
            url = this.sortBlocksUrl;
            for (i = 0; i < to.children.length; i += 1) {
                child = to.children[i];
                // Nous utilisons une route déjà existante, dédiée aux blocs, 
                // pour gérer à la fois des blocs et des headings.
                // Ca manque d'élégance.
                ids.push({
                    id: child.dataset.id,
                    kind: child.dataset.kind
                });
            }
            $.post(this.sortBlocksUrl, { ids: ids });
        } else if (event.from.classList.contains('content-editor--organize')) {
            // Mode organisation du plan
            for (i = 0; i < to.children.length; i += 1) {
                child = to.children[i];
                ids.push(child.dataset.id);
            }
            $.post(this.sortHeadingsUrl, { ids: ids });
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.contentEditor.init();
});
