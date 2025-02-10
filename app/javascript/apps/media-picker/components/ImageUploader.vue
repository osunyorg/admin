<script>
import { Upload } from 'lucide-vue-next';
import CropperModal from '../../components/CropperModal.vue';

export default {
  components: {
    Upload,
    CropperModal,
  },
  computed: {
    sizeWarningSentence: {
      get() {
        let sentence = this.i18n.size.text;
        sentence = sentence.replace(':size', this.file.size.mo);
        sentence = sentence.replace(':max', this.size.max.mo);
        return sentence;
      }
    },
  },
  data () {
    return {
      endpoint: "/rails/active_storage/direct_uploads",
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
        url: null
      },
      directUpload: null,
      i18n: {},
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
      this.directUpload.create(function (error, blob) {
        if (error) {
          console.error(error);
          return;
        }

        this.setBlob(blob);
        if (this.isResizable(this.input.object)) {
          this.$refs.cropper.launch(this.blob);
        } else {
          this.$emit('uploaded', this.blob);
        }
      }.bind(this));
    },
    setBlob(blob) {
      this.blob.id = blob.id;
      this.blob.signed_id = blob.signed_id;
      this.blob.checksum = blob.checksum;
      // png to manage transparency, even if image is a jpg (it's just a preview)
      this.blob.url = "/media/" + this.blob.signed_id + "/preview.png";
    },
    cropped(blob) {
      this.setBlob(blob);
      this.$emit('uploaded', this.blob);
    },
    isResizable (file) {
      return (/^image\/(png|jpeg)+$/).test(file.type);
    },
    closeAlert() {
      this.size.alert = false;
    },
  },
  beforeMount() {
    const dataset = document.getElementById('media-picker-app').dataset
    this.i18n = JSON.parse(dataset.i18n).mediaPicker.imageUploader;
    this.formats = {
      accepted: dataset.formatsAccepted,
      hint: dataset.formatsAcceptedHint,
    };
  },
};
</script>

<template>
  <div>
    <div class="vue__media-picker__selector__viewport">
      <input  hidden
              ref="file"
              type="file"
              :accept="formats.accepted"
              @change="uploadInputChanged($event)">
      <button type="button"
              class="btn"
              @click.prevent="$refs.file.click()">
        <Upload stroke-width="1.5" />
        {{ i18n.button }}
      </button>
      <div class="form-text">{{ formats.hint }}</div>
    </div>
    <CropperModal
      ref="cropper"
      @cropped="cropped"
      />
    <div  class="modal show"
          tabindex="-1"
          role="dialog"
          :class="{'d-block': (size.alert === true)}">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ i18n.size.title }}</h5>
            <button type="button"
                    class="btn-close"
                    @click="closeAlert()">
            </button>
          </div>
          <div class="modal-body" v-html="sizeWarningSentence">
          </div>
          <div class="modal-footer">
            <button type="button"
                    class="btn btn-sm btn-secondary ms-auto"
                    @click="closeAlert()">
              {{ i18n.size.close }}
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-backdrop show" :class="{'d-none': (size.alert !== true)}"></div>
  </div>
</template>