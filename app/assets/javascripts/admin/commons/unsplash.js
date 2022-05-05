/* global $ */
$('[data-unsplash]').click(function (e) {
    'use strict';
    var $image = $(this),
        id = $image.data('unsplash'),
        preview = $image.data('preview'),
        alt = $image.data('alt'),
        credit = $image.data('credit'),
        $inputId = $('#unsplashInput'),
        $inputImg = $($('[data-unsplash-img]').data('unsplash-img')),
        $inputAlt = $($('[data-unsplash-alt]').data('unsplash-alt')),
        $inputCredit = $($('[data-unsplash-credit]').data('unsplash-credit'));
    e.stopPropagation();
    $('[data-unsplash]').removeClass('bg-secondary');
    $image.addClass('bg-secondary');
    $inputId.val(id);
    $inputImg.attr('src', preview);
    $inputAlt.val(alt);
    $inputCredit.summernote('code', credit);
});
