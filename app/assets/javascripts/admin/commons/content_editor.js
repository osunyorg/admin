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
                onStart: this.onSortableStart.bind(this),
                onEnd: this.onSortableEnd.bind(this)
            });
            this.sortableInstances.push(sortableInstance);
        }
    },

    onSortableStart: function (evt) {
        'use strict';
        console.log('start');
        this.sortableRootContainer.classList.add('content-editor__elements__root--dragging');
    },

    onSortableEnd: function (evt) {
        'use strict';
        var item = evt.item,
            from = evt.from,
            to = evt.to,
            ids = [],
            parentId,
            url;

        console.log('end');
        this.sortableRootContainer.classList.remove('content-editor__elements__root--dragging');
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

    debugTree: function () {
        'use strict';
        console.log('TODO Debug Tree');
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
