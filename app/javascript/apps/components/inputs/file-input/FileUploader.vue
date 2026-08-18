<script>
import { useId } from 'vue';
import { Upload } from '@lucide/vue';
import Warning from '../primitives/Warning.vue';

export default {
  name: 'UploadButton',
  components: {
    Upload,
    Warning,
  },
  props: {
    endpoint: { type: String, required: true },
    accept: { type: String, required: true },
    sizeLimit: { type: Number, required: true },
  },
  emits: [
    'uploading',
    'uploaded',
  ],
  setup() {
    return { fieldId: useId() };
  },
  data() {
    return {
      draggingFileAbove: false,
      fileUploaded: null,
      sizeTooBig: false,
      uploadProgress: null,
    }
  },
  computed: {
    sizeWarningSentence: {
      get() {
        if (this.fileUploaded) {
          const size = Math.round(this.fileUploaded.size / 1024 / 1024);
          const max = this.sizeLimit / 1024 / 1024;
          return this.$t('components.inputs.mediaInput.imageUploader.size.text', {
            size: size,
            max: max,
          });
        } else {
          return "";
        }
      }
    },
  },
  methods: {
    uploadInputChanged(event) {
      this.fileUploaded = event.target.files?.[0];
      this.checkSize();
    },
    checkSize() {
      if (this.fileUploaded.size > this.sizeLimit) {
        this.sizeTooBig = true;
      } else {
        this.uploadFile();
      }
    },
    directUploadWillStoreFileWithXHR(xhr) {
      // https://guides.rubyonrails.org/active_storage_overview.html#track-the-progress-of-the-file-upload
      xhr.upload.addEventListener('progress', (event) => {
        if (event.total) {
          const percent = ((event.loaded / event.total) * 100);
          this.$emit('uploading', percent);
        }
      });
    },
    uploadFile() {
      this.$emit('uploading', 0);
      this.directUpload = new window.ActiveStorage.DirectUpload(this.fileUploaded, this.endpoint, this)
      this.directUpload.create(
        (error, data) => {
          this.$emit('uploading', null);
          if (error) {
            // eslint-disable-next-line no-console
            console.error(error);
            return;
          } else {
            this.$emit('uploaded', data.file);
          }
        },
      );
    },
    // Drop files
    draggingStart() {
      this.draggingFileAbove = true;
    },
    draggingStop() {
      this.draggingFileAbove = false;
    },
    drop($event) {
      this.draggingStop();
      const files = $event.dataTransfer ? [...$event.dataTransfer.files] : [...$event.target.files]
      this.fileUploaded = files?.[0];
      this.checkSize();
    },
  },
};
</script>

<template>
  <div
    class="mb-3"
    @dragenter.prevent="draggingStart"
    @dragover.prevent="draggingStart"
    @dragleave.prevent="draggingStop"
    @drop.prevent.stop="drop($event)"
    >
    <input
      hidden
      ref="file"
      type="file"
      class="form-control"
      :accept="accept"
      :id="fieldId"
      @change="uploadInputChanged" />
    <button
      type="button"
      class="btn btn-sm mx-n2 d-flex align-items-center"
      :class="{ 'fw-bold': draggingFileAbove }"
      @click.prevent="$refs.file.click()">
      <Upload stroke-width="1.5" class="me-1" />
      {{ $t('components.inputs.fileInput.fileUploader.upload') }}
    </button>
  </div>
  <Warning
    :active="sizeTooBig"
    :title="$t('components.inputs.fileInput.fileUploader.size.title')"
    :text="sizeWarningSentence" 
    :close="$t('components.inputs.fileInput.fileUploader.size.close')" 
    />
</template>
