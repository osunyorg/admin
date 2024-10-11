/*global $ */
$(document).ready(function () {
    'use strict';
    $('select.select2').each(function () {
        $(this)
            .wrap('<div class="position-relative"></div>')
            .select2({
                allowClear: true,
                dropdownParent: $(this).parent(),
                placeholder: ''
            });
    });
});
