/* global $ */
window.osuny = window.osuny || {};
window.osuny.pagesTree = {

    init: function () {
        'use strict';
        $('.js-tree-element').click(this.branchClicked.bind(this));
    },

    branchClicked: function (e) {
        'use strict';
        var $target = $(e.currentTarget),
            $branch = $target.parents('.js-treeview-element');

        e.preventDefault();
        e.stopPropagation();

        $branch.toggleClass('opened');

        if ($branch.hasClass('opened') && !$branch.hasClass('loaded')) {
            this.loadBranch($branch, $target.attr('href'));
        }
    },

    loadBranch: function ($branch, url) {
        'use strict';
        // TODO
        console.log('ok');
        $branch.addClass('loaded');
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
