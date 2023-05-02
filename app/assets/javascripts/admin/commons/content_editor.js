/* global $, Sortable */
window.osuny = window.osuny || {};
window.osuny.contentEditor = {

    init: function () {
        'use strict';
        this.initSortable();
    },

    initSortable: function () {
        'use strict';
        var nestedSortables,
            i;

        nestedSortables = [].slice.call(document.querySelectorAll('.js-content-editor-sortable-container'));
        for (i = 0; i < nestedSortables.length; i += 1) {
            new Sortable(nestedSortables[i], {
                group: 'nested',
                animation: 150,
                fallbackOnBody: true,
                swapThreshold: 0.65,
                onEnd: function (evt) {
                    var item = evt.item,
                        from = evt.from,
                        to = evt.to,
                        ids = [],
                        parentId,
                        url;

                    // get list of ids
                    $('> .js-content-editor-element', to).each(function () {
                        ids.push($(this).attr('data-id'));
                    });

                    // as the "to" can be the root object where the data-sort-url is set we use "closest" and not "parents"
                    url = $(to).closest('.js-content-editor-sortable')
                        .attr('data-sort-url');
                    parentId = to.dataset.id;

                    // manage emptyness
                    $(to).closest('.js-content-editor-element')
                        .removeClass('content-editor__element--empty');
                    if ($('> .js-content-editor-element', from).length === 0) {
                        $(from).closest('.js-content-editor-element')
                            .addClass('content-editor__element--empty');
                    }

                    // call to application
                    $.post(url, {
                        oldParentId: from.dataset.id,
                        parentId: parentId,
                        ids: ids,
                        itemId: item.dataset.id
                    });
                }
            });
        }
    },

    branchClicked: function (e) {
        'use strict';
        var $target = $(e.currentTarget),
            $branch = $target.closest('.js-content-editor-element');

        $branch.toggleClass('content-editor__element--opened');

        if ($branch.hasClass('content-editor__element--loaded')) {
            e.preventDefault();
            e.stopPropagation();
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this),
            initSortable: this.initSortable.bind(this)
        };
    }
}.invoke();

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.contentEditor.init();
});
