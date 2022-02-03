/*global $ */
$(function () {
    'use strict';

    var changeRole = function () {
        var value = $('select[name="user[role]"]').val(),
            showForRoles,
            required;

        $('*[data-show-for-roles]').each(function () {
            showForRoles = $(this)
                .attr('data-show-for-roles')
                .split(',');
            if ($.inArray(value, showForRoles) > -1) {
                required = $(this).attr('data-required');
                if (required) {
                    $('input, select', this).attr('required', 'required');
                } else {
                    $('input, select', this).removeAttr('required');
                }
                $(this).show();
            } else {
                $(this).hide();
                // hidden field cannot be required
                $('input, select', this).removeAttr('required');
            }
        });
    };

    if ($('body').is('.users-edit, .users-new, .users-update, .users-create')) {
        changeRole();
        $('select[name="user[role]"]').change(changeRole);
    }
});
