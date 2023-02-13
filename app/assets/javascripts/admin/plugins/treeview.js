/* global $, Sortable */
window.osuny = window.osuny || {};
window.osuny.treeView = {

    init: function () {
        'use strict';
        $('.js-treeview').on('click', '.js-treeview-openzone', this.branchClicked.bind(this));
        this.initSortable();
    },

    initSortable: function () {
        'use strict';
        var nestedSortables,
            i;

        nestedSortables = [].slice.call(document.querySelectorAll('.js-treeview-sortable-container'));
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
                    $('> .js-treeview-element', to).each(function () {
                        ids.push($(this).attr('data-id'));
                    });

                    // as the "to" can be the root object where the data-sort-url is set we use "closest" and not "parents"
                    url = $(to).closest('.js-treeview-sortable')
                        .attr('data-sort-url');
                    parentId = to.dataset.id;

                    // manage emptyness
                    $(to).closest('.js-treeview-element')
                        .removeClass('treeview__element--empty');
                    if ($('> .js-treeview-element', from).length === 0) {
                        $(from).closest('.js-treeview-element')
                            .addClass('treeview__element--empty');
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
            $branch = $target.closest('.js-treeview-element');

        $branch.toggleClass('treeview__element--opened');

        if ($branch.hasClass('treeview__element--loaded')) {
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
    window.osuny.treeView.init();
});
