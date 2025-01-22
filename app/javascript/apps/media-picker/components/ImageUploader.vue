<script>
import { Upload } from 'lucide-vue-next';
import CropperModal from '../../components/CropperModal.vue';

export default {
  components: { 
    Upload,
    CropperModal,
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
        alert: {
          active: false,
          sentence: '',
        },
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
      if (!this.size.alert.active) {
        this.uploadFile();
      }
    },
    checkSize() {
      this.file.size.bytes = this.input.object.size;
      this.file.size.mo = Math.round(this.file.size.bytes / 1024 / 1024);
      if (this.file.size.bytes > this.size.max.bytes) {
        this.size.alert.active = true;
        this.size.alert.sentence = "Le fichier est trop lourd ! (" + this.file.size.mo + " Mo > " + this.size.max.mo + " Mo)",
        alert(this.size.alert.sentence);
      }
    },
    uploadFile() {
      this.directUpload = new ActiveStorage.DirectUpload(this.input.object, this.endpoint, this);
      this.directUpload.create(function (error, blob) {
        if (error) {
          console.error(error);
        } else {
          this.setBlob(blob);
          this.$refs.cropper.launch(this.blob);
        }
      }.bind(this));
    },
    setBlob(blob) {
      this.blob.id = blob.id;
      this.blob.signed_id = blob.signed_id;
      this.blob.checksum = blob.checksum;
      this.blob.url = "/media/" + this.blob.signed_id + "/preview.jpg";
    },
    cropped(blob) {
      this.setBlob(blob);
      this.$emit('uploaded', this.blob);
    }
  },
  beforeMount() {
    this.i18n = JSON.parse(document.getElementById('media-picker-app').dataset.i18n).upload;
  },
};
</script>

<template>
  <div>
    <div class="vue__media-picker__selector__viewport">
      <input  hidden
              ref="file"
              type="file"
              :accept="i18n.formats_accepted"
              @change="uploadInputChanged($event)">
      <button type="button"
              class="btn"
              @click.prevent="$refs.file.click()">
        <Upload stroke-width="1.5" />
        {{ i18n.button }}
      </button>
      <div class="form-text">{{ i18n.hint }}</div>
    </div>
    <CropperModal
      ref="cropper" 
      @cropped="cropped"
      />
  </div>
</template>