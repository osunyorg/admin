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

        nestedSortables = [].slice.call(document.querySelectorAll('.js-treeview-sortable'));
        for (i = 0; i < nestedSortables.length; i += 1) {
            new Sortable(nestedSortables[i], {
                group: 'nested',
                animation: 150,
                fallbackOnBody: true,
                swapThreshold: 0.65,
                onEnd: function (evt) {
                    var from = evt.from,
                        to = evt.to,
                        ids = [],
                        parentId;
                    $('> .js-treeview-element', to).each(function () {
                        ids.push($(this).attr('data-id'));
                    });
                    parentId = to.dataset.id;
                    console.log(parentId, ids, from === to);
                    // TODO
                }
            });
        }
    },

    branchClicked: function (e) {
        'use strict';
        var $target = $(e.currentTarget),
            $branch = $target.closest('.js-treeview-branch');

        $branch.toggleClass('treeview__branch--opened');

        if ($branch.hasClass('treeview__branch--loaded')) {
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
