<script>
import { Upload } from '@lucide/vue';
import CropperModal from '../../CropperModal.vue';

export default {
  components: {
    Upload,
    CropperModal,
  },
  props: {
    endpoint: { type: String, required: true },
    accept: { type: String, default: '*' },
    hint: { type: String, default: '' },
  },
  emits: [
    'uploaded'
  ],
  computed: {
    sizeWarningSentence: {
      get() {
        return this.$t('components.inputs.mediaInput.imageUploader.size.text', {
          size: this.file.size.mo,
          max: this.size.max.mo,
        });
      }
    },
  },
  data () {
    return {
      input: {
        field: null,
        object: null,
      },
      file: {
        size: {
          bytes: null,
          mo: null,
        },
      },
      size: {
        max: {
          bytes: 5242880,
          mo: 5242880 / 1024 / 1024, // 5 Mo
        },
        alert: false,
      },
      blob: {
        id: null,
        signed_id: null,
        checksum: null,
        key: null,
        url: null
      },
      directUpload: null,
      keycdnUrl: null,
    }
  },
  methods: {
    uploadInputChanged(event) {
      var files = event.target.files || event.dataTransfer.files;
      if (!files.length) {
        return;
      }
      this.input.field = event.target;
      this.input.object = files[0];
      this.checkSize();
      if (!this.size.alert) {
        this.uploadFile();
      }
    },
    checkSize() {
      this.file.size.bytes = this.input.object.size;
      this.file.size.mo = Math.round(this.file.size.bytes / 1024 / 1024);
      if (this.file.size.bytes > this.size.max.bytes) {
        this.size.alert = true;
      }
    },
    uploadFile() {
      this.directUpload = new ActiveStorage.DirectUpload(this.input.object, this.endpoint, this);
      this.directUpload.create(function (error, data) {
        if (error) {
          console.error(error);
          return;
        }
        this.$emit('uploaded', data.media);
      }.bind(this));
    },
    closeAlert() {
      this.size.alert = false;
    },
  },
};
</script>

<template>
  <div>
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
    <div
      class="modal"
      tabindex="-1"
      role="dialog"
      :class="{'d-block': (size.alert === true)}">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ $t('components.inputs.mediaInput.imageUploader.size.title') }}</h5>
            <button
              type="button"
              class="btn-close"
              @click="closeAlert()">
            </button>
          </div>
          <div
            class="modal-body"
            v-html="sizeWarningSentence">
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-sm btn-secondary ms-auto"
              @click="closeAlert()">
              {{ $t('components.inputs.mediaInput.imageUploader.size.close') }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-backdrop show" :class="{'d-none': (size.alert !== true)}"></div>
  </div>
</template>
