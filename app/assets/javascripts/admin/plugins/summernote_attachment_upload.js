/*global $, ActiveStorage */
var SummernoteAttachmentUpload = function (element, file) {
    'use strict';
    this.element = element;
    this.file = file;
    this.directUpload = new ActiveStorage.DirectUpload(file, this.getDirectUploadUrl(), this);
    this.previewablePattern = /^image(\/(gif|png|jpe?g)|$)/;
    this.blobAttributes = {};
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

    this.blobAttributes = attributes;
    this.trixAttributes = {
        'content-type': attributes.content_type,
        'filename': attributes.filename,
        'filesize': attributes.byte_size,
        'previewable': this.isPreviewable(),
        'sgid': attributes.attachable_sgid,
        'url': this.createBlobUrl(attributes.signed_id, attributes.filename)
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
    var attachmentElement = document.createElement('action-text-attachment'),
        imageElement,
        keys = Object.keys(this.trixAttributes),
        i;

    for (i = 0; i < keys.length; i += 1) {
        attachmentElement.setAttribute(keys[i], this.trixAttributes[keys[i]]);
    }

    if (this.trixAttributes.previewable) {
        imageElement = document.createElement('img');
        imageElement.src = this.trixAttributes.url;
        imageElement.width = this.trixAttributes.width;
        imageElement.height = this.trixAttributes.height;
        attachmentElement.appendChild(imageElement);
    } else {
        attachmentElement.textContent = this.trixAttributes.filename;
    }

    $(this.element).summernote('insertNode', attachmentElement);
};

SummernoteAttachmentUpload.prototype.createBlobUrl = function (signedId, filename) {
    'use strict';
    return this.getBlobUrlTemplate()
        .replace(':signed_id', signedId)
        .replace(':filename', encodeURIComponent(filename));
};

SummernoteAttachmentUpload.prototype.isPreviewable = function () {
    'use strict';
    return this.previewablePattern.test(this.blobAttributes.content_type);
};

SummernoteAttachmentUpload.prototype.getClassName = function () {
    'use strict';
    var type = this.isPreviewable() ? 'preview' : 'file',
        extension = this.getFileExtension(),
        classList = [];

    classList.push('attachment');
    classList.push('attachment--' + type);
    if (extension !== null) {
        classList.push('attachment--' + extension);
    }

    return classList.join(' ');
};

SummernoteAttachmentUpload.prototype.getFileExtension = function () {
    'use strict';
    var matchResults = this.blobAttributes.filename.match(/\.(\w+)$/);
    if (matchResults !== null) {
        return matchResults[1].toLowerCase();
    }
    return null;
};

SummernoteAttachmentUpload.prototype.getDirectUploadUrl = function () {
    'use strict';
    return this.element.dataset.directUploadUrl;
};

SummernoteAttachmentUpload.prototype.getBlobUrlTemplate = function () {
    'use strict';
    return this.element.dataset.blobUrlTemplate;
};
