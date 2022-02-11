/*global ActiveStorage */
var SummernoteAttachmentUpload = function (element, file) {
    'use strict';
    this.element = element;
    this.file = file;
    this.directUpload = new ActiveStorage.DirectUpload(file, this.getDirectUploadUrl(), this);
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

    // Insert Blob in Summernote
    console.log(attributes);
    console.log({
        sgid: attributes.attachable_sgid,
        url: this.createBlobUrl(attributes.signed_id, attributes.filename)
    });
};

SummernoteAttachmentUpload.prototype.createBlobUrl = function (signedId, filename) {
    'use strict';
    return this.getBlobUrlTemplate()
        .replace(':signed_id', signedId)
        .replace(':filename', encodeURIComponent(filename));
};

SummernoteAttachmentUpload.prototype.getDirectUploadUrl = function () {
    'use strict';
    return this.element.dataset.directUploadUrl;
};

SummernoteAttachmentUpload.prototype.getBlobUrlTemplate = function () {
    'use strict';
    return this.element.dataset.blobUrlTemplate;
};
