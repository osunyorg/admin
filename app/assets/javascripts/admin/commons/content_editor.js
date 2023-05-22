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
        for (i = 0 ; i < elementsContainers.length ; i += 1) {
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

        // var root = document.getElementById("content-editor-elements-root");

        // onStart
        // this.sortableRootContainer.classList.add("content-editor__elements__root--dragging")

        // onEnd
        // this.sortableRootContainer.classList.remove("content-editor__elements--root--dragging")

        for (i = 0; i < sortableContainers.length; i += 1) {
            sortableInstance = new Sortable(sortableContainers[i], {
                group: 'nested',
                handle: '.content-editor__elements__handle',
                animation: 150,
                fallbackOnBody: true,
                swapThreshold: 0.65,
                onUnchoose: this.onSortableUnchoose.bind(this),
                onStart: this.onSortableStart.bind(this),
                onMove: this.onSortableMove.bind(this),
                onEnd: this.onSortableEnd.bind(this)
            });
            this.sortableInstances.push(sortableInstance);
        }
    },

    onSortableStart: function (event) {
        'use strict';
        var item = event.item,
            kind = item.dataset.kind;
        this.sortableRootContainer.classList.add('content-editor__elements__root--dragging');
        if (kind === 'block') {
            this.sortableRootContainer.classList.add('content-editor__elements__root--dragging-block');
        } else if (kind === 'heading') {
            this.sortableRootContainer.classList.add('content-editor__elements__root--dragging-heading');
        }
    },

    onSortableMove: function (event) {
        'use strict';
        var draggedKind = event.dragged.dataset.kind,
            relatedKind = event.related.dataset.kind;

        if (draggedKind === 'block') {
            // Prevent dragging a block after a heading, instead of inside
            return relatedKind !== 'heading' || !event.willInsertAfter;
        }
        return true;
    },

    onSortableEnd: function (event) {
        'use strict';
        var item = event.item,
            kind = item.dataset.kind,
            to = event.to,
            ids = [],
            headingId = null,
            child,
            i,
            url;

        if (kind === 'block') {
            url = this.sortBlocksUrl;
        } else if (kind === 'heading') {
            url = this.sortHeadingsUrl;
        }

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

    onSortableUnchoose: function () {
        'use strict';
        this.sortableRootContainer.classList.remove(
            'content-editor__elements__root--dragging',
            'content-editor__elements__root--dragging-block',
            'content-editor__elements__root--dragging-heading'
        );
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
