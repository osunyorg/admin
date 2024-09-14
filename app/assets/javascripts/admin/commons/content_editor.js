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
        this.offcanvasEditor = document.getElementById('offcanvasEditor');
        this.offcanvasEditorBootstrap = new bootstrap.Offcanvas(this.offcanvasEditor);
        this.offcanvasIframe = document.getElementById('offcanvasEditorIframe');
        this.addListeners('[data-bs-toggle="tab"]', 'shown.bs.tab', this.tabChanged);
        this.initSortable();
        this.initButtons();
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

    initButtons: function () {
        'use strict';
        var editButtons = document.querySelectorAll('.js-content-editor__element__edit'),
            addBlockButton = document.querySelector('.js-content-editor__add-block'),
            i,
            button;
        for (i = 0; i < editButtons.length; i += 1) {
            button = editButtons[i];
            button.addEventListener('click', this.onEditButtonClick.bind(this));
        }
        addBlockButton.addEventListener('click', this.onAddBlockButtonClick.bind(this));
    },

    onEditButtonClick: function (event) {
        'use strict';
        event.preventDefault();
        open(event.target.href, 'editor');
        this.offcanvasEditorBootstrap.show()
    },

    onAddBlockButtonClick: function (event) {
        event.preventDefault();
        open(event.target.href, 'editor');
        this.offcanvasEditorBootstrap.show()
    },

    onBlockSave: function (blockIdentifier, blockPath) {
        'use strict';
        var target = document.querySelector('#snippet-' + blockIdentifier),
            request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.status == 200) {
                target.innerHTML = request.responseText;
            }
        };
        request.open("GET", blockPath);
        request.send();
        this.offcanvasEditorBootstrap.hide();
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

    tabLoaded: function () {
        'use strict';
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

    addListeners: function (selector, event, action) {
        'use strict';
        var elements = document.querySelectorAll(selector),
            i;
        for (i = 0; i < elements.length; i += 1) {
            elements[i].addEventListener(event, action.bind(this));
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this),
            onBlockSave: this.onBlockSave.bind(this)
        };
    }
}.invoke();

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.contentEditor.init();
});
