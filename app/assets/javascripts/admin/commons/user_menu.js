/*global $ */
$('.js-user-button').click(function (e) {
    'use strict';
    e.stopPropagation();
    $('.js-user-dropdown-toggle').dropdown('toggle');
});
