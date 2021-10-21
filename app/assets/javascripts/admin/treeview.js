/* global $, Sortable */
window.osuny = window.osuny || {};
window.osuny.treeView = {

    init: function () {
        'use strict';
        $('.js-treeview').on('click', '.js-treeview-element', this.branchClicked.bind(this));
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
                onEnd: function (/**Event*/evt) {
                    console.log(evt);
            		var itemEl = evt.item;  // dragged HTMLElement
            		evt.to;    // target list
            		evt.from;  // previous list
            		evt.oldIndex;  // element's old index within old parent
            		evt.newIndex;  // element's new index within new parent
            		evt.oldDraggableIndex; // element's old index within old parent, only counting draggable elements
            		evt.newDraggableIndex; // element's new index within new parent, only counting draggable elements
            		evt.clone // the clone element
            		evt.pullMode;  // when item is in another sortable: `"clone"` if cloning, `true` if moving
            	},
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
