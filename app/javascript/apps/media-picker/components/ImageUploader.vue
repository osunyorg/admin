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
    <div class="modal show" tabindex="-1" role="dialog" :class="{'d-block': size.alert}">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Image trop lourde</h5>
            <button type="button" class="btn-close" @click="size.alert = false"></button>
          </div>
          <div class="modal-body">
            <p>
              L'image envoyée est beaucoup trop lourde !
              Elle pèse {{ this.file.size.mo }}Mo, 
              alors que le maximum autorisé est de {{ this.size.max.mo }}Mo.
              Il est nécessaire de la réduire avant de l'envoyer, 
              par exemple en utilisant un outil comme 
              <a href="https://www.iloveimg.com/fr " target="_blank" rel="noreferrer">iLoveIMG</a>.
            </p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-sm btn-secondary ms-auto" @click="size.alert = false">
              Fermer
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-backdrop show" :class="{'d-none': !size.alert}"></div>
  </div>
</template>