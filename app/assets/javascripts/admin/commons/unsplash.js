/* global $ */
$('[data-unsplash]').click(function (e) {
    'use strict';
    var $image = $(this),
        id = $image.data('unsplash'),
        preview = $image.data('preview'),
        alt = $image.data('alt'),
        credit = $image.data('credit'),
        $input = $('#unsplashInput');
    e.stopPropagation();
    $('[data-unsplash]').removeClass('bg-secondary');
    $('#communication_website_post_featured_image_alt').val(alt);
    $('#communication_website_post_featured_image_credit').summernote('code', credit);
    $('.communication_website_post_featured_image img').attr('src', preview);
    $image.addClass('bg-secondary');
    $input.val(id);
});
