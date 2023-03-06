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
                    objectId: id,
                    objectType: type
                }
            }).done(function () {
                location.reload();
            });
        });
});
