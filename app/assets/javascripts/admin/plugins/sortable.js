/*global $, Sortable */
$(function () {
    'use strict';
    // Re-order elements of a table. Needs a "table-sortable" class on the table, a "data-reorder-url" param on the tbody and a "data-id" param on each tr
    var nestedSortables = [].slice.call(document.querySelectorAll('.table-sortable tbody')),
        i;
    for (i = 0; i < nestedSortables.length; i += 1) {
        new Sortable(nestedSortables[i], {
            handle: '.handle',
            group: 'nested',
            animation: 150,
            fallbackOnBody: true,
            swapThreshold: 0.65,
            onEnd: function (evt) {
                var to = evt.to,
                    ids = [],
                    url = $(to).attr('data-reorder-url');
                // get list of ids
                $('> tr', to).each(function () {
                    ids.push($(this).attr('data-id'));
                });
                $.post(url, { ids: ids });
            }
        });
    }
});
