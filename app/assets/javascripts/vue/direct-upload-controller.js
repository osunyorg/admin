/*global Vue */
Vue.DirectUploadController = function DirectUploadController (input, file, url) {
    'use strict';
    this.input = input;
    this.file = file;
    this.url = url;
    this.directUpload = new ActiveStorage.DirectUpload(this.file, this.url, this)
    this.dispatch("initialize");
}

Vue.DirectUploadController.prototype.start = function (callback) {
    'use strict';
    this.directUpload.create(function (error, blob) {
        this.dispatch("end");
        if (error) {
            console.log(error);
        } else {
            callback(blob);
        }
    }.bind(this));
}

Vue.DirectUploadController.prototype.uploadRequestDidProgress = function (event) {
    'use strict';
    var progress = event.loaded / event.total * 100
    if (progress) {
        this.dispatch("progress", { "progress": progress });
    }
}

Vue.DirectUploadController.prototype.dispatch = function (name, detail) {
    var event = document.createEvent("Event"),
        eventName = 'direct-upload:' + name,
        disabled = this.input.disabled;
    detail = detail || {};
    detail.file = this.file;
    detail.id = this.directUpload.id;
    event.initEvent(eventName, true, true);
    event.detail = detail;

    this.input.disabled = false;
    this.input.dispatchEvent(event);
    this.input.disabled = disabled;

    return event;
}

// DirectUpload delegate

Vue.DirectUploadController.prototype.directUploadWillStoreFileWithXHR = function (xhr) {
    'use strict';
    xhr.upload.addEventListener("progress", this.uploadRequestDidProgress.bind(this));
}