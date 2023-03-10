/*global $ */
$(function () {
    'use strict';
    var setAutocompleteTargetValue,
        setAutocompleteNothingFound;

    setAutocompleteTargetValue = function (targetId, value) {
        var targetInput = document.querySelector(targetId);
        if (targetInput) {
            targetInput.value = value;
        }
    };

    setAutocompleteNothingFound = function (target, search) {
        var defaultText,
            text;
        if (target) {
            defaultText = target.dataset.defaultText;
            text = defaultText.replaceAll('CHANGEME', search);
            target.innerHTML = text;
            target.classList.remove('d-none');
        }
    };

    $('input.autocomplete')
        .on('input', function ($event) {
            setAutocompleteTargetValue($event.target.dataset.autocompleteTarget, '');
        })
        .on('railsAutocomplete.select', function ($event, data) {
            var noResultTarget = document.querySelector($event.target.dataset.autocompleteNoResultTarget);
            setAutocompleteTargetValue($event.target.dataset.autocompleteTarget, data.item.id);
            noResultTarget.classList.add('d-none');
        })
        .on('railsAutocomplete.source', function ($event, data) {
            var noResultTarget = document.querySelector($event.target.dataset.autocompleteNoResultTarget);
            if (data.length === 0) {
                setAutocompleteNothingFound(noResultTarget, $event.target.value);
            } else {
                noResultTarget.classList.add('d-none');
            }
        });
});
