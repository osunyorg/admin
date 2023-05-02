/* global $, Sortable */
window.osuny = window.osuny || {};
window.osuny.contentEditor = {

    init: function () {
        'use strict';
        this.container = document.querySelector('.js-content-editor');
        if (this.container === null) {
            return;
        }

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
                onChoose: this.onSortableChoose.bind(this),
                onUnchoose: this.onSortableUnchoose.bind(this),
                onStart: this.onSortableStart.bind(this),
                onEnd: this.onSortableEnd.bind(this)
            });
            this.sortableInstances.push(sortableInstance);
        }
    },

    onSortableChoose: function (event) {
        'use strict';
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
        if (event.to.id === 'content-editor-elements-root') {
            // Dragged to root list
            console.log('no parent');
            console.log([...event.to.children].map(item => `${item.dataset.kind}-${item.dataset.id}`));
        } else {
            // Dragged to element's children list
            console.log('parent id is: ', evt.to.parentNode.dataset.id);
        }
    },

    onSortableEnd: function (event) {
        'use strict';
        var item = event.item,
            from = event.from,
            to = event.to,
            ids = [],
            parentId,
            url;

        console.log('end');

        // // get list of ids
        // $('> .js-content-editor-element', to).each(function () {
        //     ids.push($(this).attr('data-id'));
        // });

        // // as the "to" can be the root object where the data-sort-url is set we use "closest" and not "parents"
        // url = $(to).closest('.js-content-editor-sortable')
        //     .attr('data-sort-url');
        // parentId = to.dataset.id;

        // // manage emptyness
        // $(to).closest('.js-content-editor-element')
        //     .removeClass('content-editor__element--empty');
        // if ($('> .js-content-editor-element', from).length === 0) {
        //     $(from).closest('.js-content-editor-element')
        //         .addClass('content-editor__element--empty');
        // }

        // // call to application
        // $.post(url, {
        //     oldParentId: from.dataset.id,
        //     parentId: parentId,
        //     ids: ids,
        //     itemId: item.dataset.id
        // });
    },

    onSortableUnchoose: function (event) {
        'use strict';
        this.sortableRootContainer.classList.remove('content-editor__elements__root--dragging');
        this.sortableRootContainer.classList.remove('content-editor__elements__root--dragging-block');
        this.sortableRootContainer.classList.remove('content-editor__elements__root--dragging-heading');
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
