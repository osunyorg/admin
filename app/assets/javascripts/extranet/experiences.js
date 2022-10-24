/*global $ */
$(function () {
    'use strict';
    var setAutocompleteTargetValue = function (targetId, value) {
        var targetInput = document.querySelector(targetId);
        if (targetInput) {
            targetInput.value = value;
        }
    };

    $('input.autocomplete')
        .on('input', function ($event) {
            setAutocompleteTargetValue($event.target.dataset.autocompleteTarget, '');
        })
        .on('railsAutocomplete.select', function ($event, data) {
            setAutocompleteTargetValue($event.target.dataset.autocompleteTarget, data.item.id);
        });
});
