/* global */
window.osuny.BatchSelectable = function BatchSelectable (element) {
    'use strict';
    this.element = element;
    this.selectAllInput = this.element.querySelector('[data-batch-selectable-role="select-all"]');
    this.selectSingleInputs = this.element.querySelectorAll('[data-batch-selectable-role="select-single"]');
    this.initEvents();
};

window.osuny.BatchSelectable.prototype.initEvents = function () {
    'use strict';
    if (this.selectAllInput === null) {
        return;
    }
    this.selectAllInput.addEventListener('change', function () {
        this.toggleSingleInputs(this.selectAllInput.checked);
    }.bind(this));
};

window.osuny.BatchSelectable.prototype.toggleSingleInputs = function (checked) {
    'use strict';
    var i;
    for (i = 0; i < this.selectSingleInputs.length; i += 1) {
        this.selectSingleInputs[i].checked = checked;
    }
};

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    var elements = document.querySelectorAll('[data-batch-selectable]'),
        i;
    for (i = 0; i < elements.length; i += 1) {
        new window.osuny.BatchSelectable(elements[i]);
    }
});
