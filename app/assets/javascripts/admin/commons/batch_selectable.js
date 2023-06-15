/* global */
window.osuny.BatchSelectable = function BatchSelectable (element) {
    'use strict';
    this.element = element;
    this.selectAllInput = this.element.querySelector('[data-batch-selectable-role="select-all"]');
    this.selectSingleInputs = this.element.querySelectorAll('[data-batch-selectable-role="select-single"]');
    this.actionsContainer = this.element.querySelector('[data-batch-selectable-role="actions-container"]');
    this.initEvents();
    this.toggleActionsContainer();
};

window.osuny.BatchSelectable.prototype.initEvents = function () {
    'use strict';
    var i;
    if (this.selectAllInput !== null) {
        this.selectAllInput.addEventListener('change', this.toggleSingleInputs.bind(this));
    }
    if (this.actionsContainer !== null) {
        for (i = 0; i < this.selectSingleInputs.length; i += 1) {
            this.selectSingleInputs[i].addEventListener('change', this.toggleActionsContainer.bind(this));
        }
    }
};

window.osuny.BatchSelectable.prototype.toggleSingleInputs = function (event) {
    'use strict';
    var checked = event.currentTarget.checked,
        i;
    for (i = 0; i < this.selectSingleInputs.length; i += 1) {
        this.selectSingleInputs[i].checked = checked;
    }
    if (this.actionsContainer !== null) {
        this.toggleActionsContainer();
    }
};

window.osuny.BatchSelectable.prototype.toggleActionsContainer = function () {
    'use strict';
    var i;
    for (i = 0; i < this.selectSingleInputs.length; i += 1) {
        if (this.selectSingleInputs[i].checked) {
            this.actionsContainer.classList.remove('d-none');
            return;
        }
    }
    this.actionsContainer.classList.add('d-none');
};

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    var elements = document.querySelectorAll('[data-batch-selectable]'),
        i;
    for (i = 0; i < elements.length; i += 1) {
        new window.osuny.BatchSelectable(elements[i]);
    }
});
