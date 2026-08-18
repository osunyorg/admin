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
    sizeLimit: { type: Number, required: true },
  },
  emits: [
    'uploading',
    'uploaded',
  ],
  computed: {
    sizeWarningSentence: {
      get() {
        if (this.input.object) {
          const size = Math.round(this.input.object.size / 1024 / 1024);
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
  data () {
    return {
      input: {
        field: null,
        object: null,
      },
      sizeTooBig: false,
    }
  },
  methods: {
    uploadInputChanged(event) {
      this.input.field = event.target;
      this.input.object = event.target.files?.[0];
      this.checkSize();
      if (!this.sizeTooBig) {
        this.uploadFile();
      }
    },
    checkSize() {
      if (this.input.object.size > this.sizeLimit) {
        this.sizeTooBig = true;
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
      this.directUpload = new window.ActiveStorage.DirectUpload(this.input.object, this.endpoint, this)
      this.directUpload.create(
        (error, data) => {
          this.$emit('uploading', null);
          if (error) {
            // eslint-disable-next-line no-console
            console.error(error);
            return;
          } else {
            this.$emit('uploaded', data.media);
          }
        },
      );
    },
    closeAlert() {
      this.size.alert = false;
    },
  },
};
</script>

<template>
  <div class="vue__media-picker__selector__viewport">
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
