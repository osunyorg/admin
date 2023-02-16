/*global $ */
$(function () {
    'use strict';
    $('input.autocomplete')
        .on('railsAutocomplete.select', function ($event, data) {
            var type = $event.target.dataset.type,
                target = $event.target.dataset.target,
                id = data.item.id;
            $.ajax({
                type: 'POST',
                url: target,
                data: {
                    object_id: id,
                    object_type: type
                }
            }).done(function () {
                location.reload();
            });
        });
});
