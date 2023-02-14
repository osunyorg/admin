/*global $ */
$(function () {
    'use strict';
    $('input.autocomplete')
        .on('railsAutocomplete.select', function ($event, data) {
            var connect = $event.target.dataset.connect,
                id = data.item.id,
                url = connect.replace(':dependency_id', id);
            $.ajax({
                type: 'POST',
                url: url
            }).done(function () {
                location.reload();
            });
        });
});
