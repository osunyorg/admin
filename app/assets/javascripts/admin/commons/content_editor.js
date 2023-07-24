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
        this.modeWriteContainer = this.container.querySelector('#mode-write-container');
        this.modeStructureContainer = this.container.querySelector('#mode-structure-container');
        this.initTabs();
        this.initSortable();
    },

    initTabs: function () {
        'use strict';
        var tabs = document.querySelectorAll('[data-bs-toggle="tab"]'),
            i;
        for (i = 0; i < tabs.length; i++) {
            tabs[i].addEventListener('shown.bs.tab', this.tabChanged.bind(this));
        }
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

    tabChanged: function (event) {
        'use strict';
        var tab = event.target,
            id = tab.getAttribute('data-bs-target'),
            div = this.container.querySelector(id),
            source = div.dataset.source;
        this.target = this.container.querySelector(div.dataset.target);
        this.target.innerHTML = '';
        this.xhr = new XMLHttpRequest();
        this.xhr.open('GET', source, true);
        this.xhr.onreadystatechange = this.tabLoaded.bind(this);
        this.xhr.send();
    },

    tabLoaded: function (event) {
        if (this.xhr.readyState === XMLHttpRequest.DONE) {
            if (this.xhr.status === 200) {
                this.target.innerHTML = this.xhr.responseText;
                this.initSortable();
            }
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

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.contentEditor.init();
});
