(function() {

  addEventListener("trix-attachment-add", function(event) {
      var file = event.attachment.file;
    if (file) {
      var upload = new window.ActiveStorage.DirectUpload(file,'/rails/active_storage/direct_uploads', window);
      upload.create((error, attributes) => {
        if (error) {
          return false;
        } else {
          return event.attachment.setAttributes({
            url: `/rails/active_storage/blobs/${attributes.signed_id}/${attributes.filename}`,
            href: `/rails/active_storage/blobs/${attributes.signed_id}/${attributes.filename}`,
          });
        }
      });
    }
  })

})();
