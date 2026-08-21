<script>
// Bulk image upload — picks N files at once, pushes a cloned `defaultElement`
// into `data.elements` for each file, and uploads them in parallel into
// `element[targetKey]`. Used by the gallery template. Each in-flight file
// gets its own progress tracker in `uploads`, keyed by its index in
// `data.elements` at push time.

export default {
  name: 'MultiImageInput',
  props: {
    // The reactive elements array (`data.elements`). We push into it directly
    // — the parent does NOT use v-model since we never emit a replacement.
    elements: { type: Array, required: true },
    defaultElement: { type: Object, required: true },
    // Property of each element that receives the uploaded blob.
    targetKey: { type: String, default: 'image' },
    accept: { type: String, default: '*' },
    sizeLimit: { type: [String, Number], default: null },
    hint: { type: String, default: '' },
  },
  inject: ['directUpload'],
  data() {
    return {
      // Live progress per in-flight upload, keyed by index in the elements
      // array at push time.
      uploads: {},
    };
  },
  computed: {
    activeUploads() {
      return Object.entries(this.uploads).filter(([, u]) => u.uploading);
    },
    effectiveSizeLimit() {
      // The gallery template always passes an explicit limit; the fallback
      // is just a safety net for unexpected callsites.
      return parseInt(this.sizeLimit, 10) || (10 * 1024 * 1024);
    },
  },
  methods: {
    onChange(event) {
      const files = event.target.files || event.dataTransfer?.files;
      if (!files || !files.length) return;

      Array.from(files).forEach((file) => {
        if (file.size > this.effectiveSizeLimit) {
          const sizeMo = Math.round(file.size / 1024 / 1024);
          const limitMo = Math.round(this.effectiveSizeLimit / 1024 / 1024);
          // eslint-disable-next-line no-alert
          alert(`File is too big (${sizeMo} Mo > ${limitMo} Mo)`);
          return;
        }
        const index = this.elements.length;
        this.elements.push(JSON.parse(JSON.stringify(this.defaultElement)));
        this.startUpload(file, index);
      });

      // Reset the input so re-selecting the same file fires `change` again.
      event.target.value = '';
    },
    startUpload(file, index) {
      this.uploads[index] = { uploading: true, progress: 0 };
      // We need to mutate via the reactive proxy, not the literal we just
      // wrote — Vue 3's reactivity only traps writes that go through the
      // proxy, so a closure-captured plain object would silently no-op.
      const uploads = this.uploads;

      const delegate = {
        directUploadWillStoreFileWithXHR(xhr) {
          xhr.upload.addEventListener('progress', (event) => {
            if (event.total) uploads[index].progress = (event.loaded / event.total) * 100;
          });
        },
      };

      new window.ActiveStorage.DirectUpload(file, this.directUpload.url, delegate).create(
        (error, blob) => {
          uploads[index].uploading = false;
          if (error) {
            // eslint-disable-next-line no-console
            console.error(error);
            return;
          }
          this.elements[index][this.targetKey] = {
            id: blob.id,
            signed_id: blob.signed_id,
            filename: blob.filename,
          };
        },
      );
    },
  },
};
</script>

<template>
  <div>
    <input
      type="file"
      class="form-control mb-3"
      :accept="accept"
      multiple
      @change="onChange" />
    <div v-if="activeUploads.length" class="mb-3">
      <progress
        v-for="[key, upload] in activeUploads"
        :key="key"
        :value="upload.progress"
        max="100"
        style="width: 100%; display: block;"></progress>
    </div>
    <div v-if="hint" class="form-text mb-2" v-html="hint"></div>
  </div>
</template>
