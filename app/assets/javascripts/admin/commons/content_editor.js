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

        this.initElements();
        this.initSortable();
    },

    initElements: function () {
        'use strict';
        var elementsContainers = this.container.querySelectorAll('.js-content-editor-element'),
            elementInstance,
            i;

        this.elements = [];
        for (i = 0; i < elementsContainers.length; i += 1) {
            elementInstance = new window.osuny.contentEditor.Element(elementsContainers[i]);
            this.elements.push(elementInstance);
        }
    },

    initSortable: function () {
        'use strict';
        var sortableContainers = this.container.querySelectorAll('.js-content-editor-sortable-container'),
            sortableInstance,
            i;

        this.sortableRootContainer = document.getElementById('content-editor-elements-root');
        this.sortableInstances = [];

        for (i = 0; i < sortableContainers.length; i += 1) {
            sortableInstance = new Sortable(sortableContainers[i], {
                handle: '.content-editor__elements__handle',
                fallbackOnBody: false,
                onEnd: this.onSortableEnd.bind(this)
            });
            this.sortableInstances.push(sortableInstance);
        }
    },

    onSortableEnd: function (event) {
        'use strict';
        var item = event.item,
            kind = item.dataset.kind,
            url = this.getUrlFromKind(kind),
            to = event.to,
            ids = [],
            headingId = null,
            child,
            i;

        if (to.id !== 'content-editor-elements-root') {
            // Dragged to heading's children list
            headingId = event.to.parentNode.dataset.id;
        }

        for (i = 0; i < to.children.length; i += 1) {
            child = to.children[i];
            if (child.dataset.kind === kind) {
                ids.push(child.dataset.id);
            }
        }

        // call to application
        $.post(url, {
            heading: headingId,
            ids: ids
        });
    },

    getUrlFromKind: function (kind) {
        'use strict';
        if (kind === 'block') {
            return this.sortBlocksUrl;
        } else if (kind === 'heading') {
            return this.sortHeadingsUrl;
        }
        return null;
    },

    getElementById: function (id) {
        'use strict';
        return this.elements[id];
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
