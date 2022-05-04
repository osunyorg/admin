/* global $ */
$('[data-unsplash]').click(function (e) {
    'use strict';
    var id = $(this).data('unsplash'),
        input = $('#unsplash');
    e.stopPropagation();
    input.val(id);
});
