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

        // e.preventDefault();
        // e.stopPropagation();

        $branch.toggleClass('treeview__branch--opened');

        // if ($branch.hasClass('treeview__branch--opened') && !$branch.hasClass('treeview__branch--loaded')) {
        //     this.loadBranch($branch, $target.attr('href'));
        // }
    },

    loadBranch: function ($branch, url) {
        'use strict';
        $.get(url, function (data) {
            $('.js-treeview-children', $branch).html(data);
            $branch.addClass('treeview__branch--loaded');
        });
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
