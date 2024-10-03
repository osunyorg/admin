/* global Sortable */
window.osuny.contentEditor.sort = {
    init: function () {
        'use strict';
        this.container = document.querySelector('.js-content-editor');
        this.sortableContainers = this.container.querySelectorAll('.js-content-editor-sortable-container');
        this.sortHeadingsUrl = this.container.getAttribute('data-sort-headings-url');
        this.sortBlocksUrl = this.container.getAttribute('data-sort-blocks-url');
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
        if (event.from.classList.contains('content-editor--write')) {
            this.sortModeWrite(event.to);
        } else if (event.from.classList.contains('content-editor--organize')) {
            this.sortModeOrganize(event.to);
        }
    },

    // Mode écriture du contenu
    sortModeWrite: function (to) {
        'use strict';
        var ids = [],
            child,
            i;
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
    },

    // Mode organisation du plan
    sortModeOrganize: function (to) {
        'use strict';
        var ids = [],
            child,
            i;
        for (i = 0; i < to.children.length; i += 1) {
            child = to.children[i];
            ids.push(child.dataset.id);
        }
        $.post(this.sortHeadingsUrl, { ids: ids });
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();