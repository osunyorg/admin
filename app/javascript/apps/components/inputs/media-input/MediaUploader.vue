<script>
import { Upload } from '@lucide/vue';
import CropperModal from '../../CropperModal.vue';
import Warning from '../primitives/Warning.vue';

export default {
  name: 'MediaUploader',
  components: {
    CropperModal,
    Upload,
    Warning,
  },
  props: {
    endpoint: { type: String, required: true },
    accept: { type: String, default: '*' },
    hint: { type: String, default: '' },
    sizeLimit: { type: Number, required: true }
  },
  emits: [
    'uploading',
    'uploaded',
  ],
  data () {
    return {
      fileUploaded: null,
      sizeTooBig: false,
      uploadProgress: null,
      draggingFileAbove: false,
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
    isUploading() {
      return this.uploadProgress !== null;
    },
  },
  methods: {
    uploadInputChanged(event) {
      if (this.isUploading) {
        return;
      }
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
          this.uploadProgress = percent;
          this.$emit('uploading', percent);
        }
      });
    },
    uploadFile() {
      this.uploadProgress = 0
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
            this.$emit('uploaded', data.media);
            this.uploadProgress = null;
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
    class="vue__media-input__uploader"
    :class="{ 'vue__media-input__uploader--dragging': draggingFileAbove }"
    @dragenter.prevent="draggingStart"
    @dragover.prevent="draggingStart"
    @dragleave.prevent="draggingStop"
    @drop.prevent.stop="drop($event)"
    >
    <div
      class="vue__media-input__uploader__progress"
      ref="progress"
      :style="{ 'height': uploadProgress + '%' }">
    </div>
    <span
      v-show="isUploading"
      class="spinner-border spinner-border-sm" role="status">
    </span>
    <div v-show="!isUploading">
      <input
        hidden
        ref="file"
        type="file"
        :accept="accept"
        @change="uploadInputChanged">
      <button
        type="button"
        class="btn"
        @click.prevent="$refs.file.click()">
        <Upload stroke-width="1.5" />
        {{ $t('components.inputs.mediaInput.imageUploader.button') }}
      </button>
      <div class="form-text">{{ hint }}</div>
    </div>
  </div>
  <!--
  <CropperModal
    ref="cropper"
    @cropped="cropped"
    />
  -->
  <Warning
    :active="sizeTooBig"
    :title="$t('components.inputs.mediaInput.imageUploader.size.title')"
    :text="sizeWarningSentence" 
    :close="$t('components.inputs.mediaInput.imageUploader.size.close')" 
    />
</template>
