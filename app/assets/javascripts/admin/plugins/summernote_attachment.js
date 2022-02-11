/*global $ */
var SummernoteAttachment = function (element) {
    'use strict';
    this.element = element;
    this.trixAttributes = JSON.parse(element.getAttribute('data-trix-attachment'));
    this.setContent();
};

SummernoteAttachment.prototype.setContent = function () {
    'use strict';
    var imageElement;
    if (this.trixAttributes.previewable) {
        imageElement = document.createElement('img');
        imageElement.src = this.trixAttributes.url;
        imageElement.width = this.trixAttributes.width;
        imageElement.height = this.trixAttributes.height;
        this.element.appendChild(imageElement);
    } else {
        this.element.textContent = this.trixAttributes.filename;
    }
};
