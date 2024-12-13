/*global $ */
$(function () {
    'use strict';
    var mode = '';
    $('.preview__button').on('click', function () {
        mode = $(this).data('mode');
        $('.preview__button')
            .removeClass('active');
        $(this)
            .addClass('active');
        $('#preview')
            .removeClass('preview--desktop')
            .removeClass('preview--tablet')
            .removeClass('preview--mobile')
            .addClass('preview--' + mode);
    });
});
