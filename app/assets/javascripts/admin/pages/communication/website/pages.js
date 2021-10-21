/* global $ */
window.osuny = window.osuny || {};
window.osuny.pagesTree = {

    init: function () {
        'use strict';
        $('.js-treeview').on('click', '.js-treeview-element', this.branchClicked.bind(this));
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
            init: this.init.bind(this)
        };
    }
}.invoke();

document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.osuny.pagesTree.init();
});
