<script>
import { Upload } from '@lucide/vue';
import Warning from '../primitives/Warning.vue';

export default {
  name: 'MediaUploader',
  components: {
    Upload,
    Warning,
  },
  props: {
    endpoint: { type: String, required: true },
    accept: { type: String, default: '*' },
    hint: { type: String, default: '' },
    multiple: { type: Boolean, default: false },
    sizeLimit: { type: Number, required: true }
  },
  emits: [
    'uploading',
    'uploaded',
  ],
  data () {
    return {
      dragging: false,
      fileUploaded: null,
      filesSelected: [],
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
    isUploading() {
      return this.uploadProgress !== null;
    },
    buttonKey() {
      if (this.multiple) {
        return 'components.inputs.mediaInput.imageUploader.buttonMultiple';
      } else {
        return 'components.inputs.mediaInput.imageUploader.button';
      }
    },
  },
  methods: {
    // File input
    uploadInputChanged(event) {
      if (this.isUploading) {
        return;
      }
      this.filesSelected = [...event.target.files];
      this.upload();
    },

    // Drop files
    drop($event) {
      this.dragging = false;
      if (this.isUploading) {
        return;
      }
      this.filesSelected = [...$event.dataTransfer.files];
      this.upload();
    },

    // Direct upload
    upload() {
      this.fileUploaded = this.filesSelected.shift();
      if (this.fileUploaded) {
        this.checkSize();
      }
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
      this.uploadProgress = 0;
      this.$emit('uploading', 0);
      this.directUpload = new window.ActiveStorage.DirectUpload(this.fileUploaded, this.endpoint, this)
      this.directUpload.create(
        (error, data) => {
          this.uploadProgress = null;
          this.$emit('uploading', null);
          if (error) {
            // eslint-disable-next-line no-console
            console.error(error);
            return;
          } else {
            this.$emit('uploaded', data.media);
            if (this.multiple) {
              this.upload();
            }
          }
        },
      );
    },
  },
};
</script>

<template>
  <div
    class="vue__media-input__uploader"
    :class="{ 'vue__media-input__uploader--dragging': dragging }"
    @dragenter.prevent="dragging = true"
    @dragover.prevent="dragging = true"
    @dragleave.prevent="dragging = false"
    @drop.prevent.stop="drop($event)"
    >
    <div
      class="vue__media-input__uploader__progress"
      ref="progress"
      :style="{ 'height': uploadProgress + '%' }"
      v-show="isUploading"
      >
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
        :multiple="multiple"
        :accept="accept"
        @change="uploadInputChanged"
        >
      <button
        type="button"
        class="btn"
        @click.prevent="$refs.file.click()"
        >
        <Upload stroke-width="1.5" />
        {{ $t(buttonKey) }}
      </button>
      <div class="form-text">{{ hint }}</div>
    </div>
  </div>
  <Warning
    :active="sizeTooBig"
    :title="$t('components.inputs.mediaInput.imageUploader.size.title')"
    :text="sizeWarningSentence" 
    :close="$t('components.inputs.mediaInput.imageUploader.size.close')" 
    />
</template>
