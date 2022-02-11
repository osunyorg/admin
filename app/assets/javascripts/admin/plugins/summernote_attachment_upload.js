/*global $, ActiveStorage */
var SummernoteAttachmentUpload = function (element, file) {
    'use strict';
    this.element = element;
    this.file = file;
    this.directUpload = new ActiveStorage.DirectUpload(file, this.getDirectUploadUrl(), this);
    this.previewablePattern = /^image(\/(gif|png|jpe?g)|$)/;
    this.trixAttributes = {};
};

SummernoteAttachmentUpload.prototype.start = function () {
    'use strict';
    this.directUpload.create(this.directUploadDidComplete.bind(this));
};

SummernoteAttachmentUpload.prototype.directUploadDidComplete = function (error, attributes) {
    'use strict';
    if (error) {
        throw new Error('Direct upload failed: ' + error);
    }

    this.trixAttributes = {
        contentType: attributes.content_type,
        filename: attributes.filename,
        filesize: attributes.byte_size,
        previewable: this.isPreviewable(attributes.content_type),
        sgid: attributes.attachable_sgid,
        url: this.createBlobUrl(attributes.signed_id, attributes.filename)
    };

    if (this.trixAttributes.previewable) {
        this.preloadAndInsertAttachment();
    } else {
        this.insertAttachment();
    }
};

SummernoteAttachmentUpload.prototype.preloadAndInsertAttachment = function () {
    'use strict';
    var objectUrl = URL.createObjectURL(this.file),
        img = new Image(),
        that = this;

    img.onload = function () {
        that.trixAttributes.width = this.width;
        that.trixAttributes.height = this.height;
        URL.revokeObjectURL(objectUrl);
        that.insertAttachment();
    };
    img.src = objectUrl;
};

SummernoteAttachmentUpload.prototype.insertAttachment = function () {
    'use strict';
    var attachmentElement = document.createElement('figure');
    attachmentElement.setAttribute('data-trix-attachment', JSON.stringify(this.trixAttributes));

    // TODO <img> or text
    attachmentElement.textContent = this.trixAttributes.filename;

    $(this.element).summernote('insertNode', attachmentElement);
};

SummernoteAttachmentUpload.prototype.createBlobUrl = function (signedId, filename) {
    'use strict';
    return this.getBlobUrlTemplate()
        .replace(':signed_id', signedId)
        .replace(':filename', encodeURIComponent(filename));
};

SummernoteAttachmentUpload.prototype.isPreviewable = function (contentType) {
    'use strict';
    return this.previewablePattern.test(contentType);
};

SummernoteAttachmentUpload.prototype.getDirectUploadUrl = function () {
    'use strict';
    return this.element.dataset.directUploadUrl;
};

SummernoteAttachmentUpload.prototype.getBlobUrlTemplate = function () {
    'use strict';
    return this.element.dataset.blobUrlTemplate;
};
