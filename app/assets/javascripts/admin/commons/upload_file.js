const uploadFile = (file) => {
  // TODO  should be data-direct-upload-url
  const url = '/rails/active_storage/direct_uploads'
  const upload = new ActiveStorage.DirectUpload(file, url)

  upload.create((error, blob) => {
    if (error) {
      alert(error)
    } else {
        console.log(blob)
      return blob
    }
  })
}
