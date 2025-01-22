<script>
import { Upload } from 'lucide-vue-next';
import { Cropper } from 'vue-advanced-cropper';

export default {
  components: { 
    Upload,
    Cropper
  },
  data () {
    return {
      endpoints: {
        upload: "/rails/active_storage/direct_uploads",
        resize: "/media/resize/", // signed_id will be added
      },
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
      crop: {
        modal: false,
        data: {
          rotation: 0,
          left: null,
          top: null,
          width: null,
          height: null,
        },
      },
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
      this.directUpload = new ActiveStorage.DirectUpload(this.input.object, this.endpoints.upload, this);
      this.directUpload.create(function (error, blob) {
        if (error) {
          console.error(error);
        } else {
          this.setBlob(blob);
          this.cropperOpen();
        }
      }.bind(this));
    },
    setBlob(blob) {
      this.blob.id = blob.id;
      this.blob.signed_id = blob.signed_id;
      this.blob.checksum = blob.checksum;
      this.blob.url = "/media/" + this.blob.signed_id + "/preview.jpg";
    },
    cropperOpen() {
      this.crop.modal = true;
      document.body.classList.add("modal-open");
    },
    cropperClose() {
      this.crop.modal = false;
      document.body.classList.remove("modal-open");
    },
		cropperChange({ coordinates }) {
      this.crop.data.left = coordinates.left;
      this.crop.data.top = coordinates.top;
      this.crop.data.width = coordinates.width;
      this.crop.data.height = coordinates.height;
		},
    cropperSize({ imageSize }) {
      return {
        width: imageSize.width,
        height: imageSize.height,
      };
    },
		rotate(angle) {
      this.crop.data.rotation += angle;
			this.$refs.cropper.rotate(angle);
		},
    cropperCrop() {
      let xhr = new XMLHttpRequest();
      let url = this.endpoints.resize + this.blob.signed_id;
      xhr.open("POST", url, true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', document.querySelector('[name="csrf-token"]').content);
      xhr.onreadystatechange = function () {
        if (xhr.readyState != 4) return;
        if (xhr.status == 200) {
          let blob = JSON.parse(xhr.responseText); 
          this.setBlob(blob);
          this.$emit('uploaded', this.blob);
        }
      }.bind(this);
      xhr.send(JSON.stringify(this.crop.data));
      this.cropperClose();
    },
  },
  beforeMount() {
    this.i18n = JSON.parse(document.getElementById('media-picker-app').dataset.i18n).upload;
  },
};
// Sur le cropper, On utilise canvas=false et check-orientation=false pour éviter les problèmes de CORS
// https://github.com/advanced-cropper/vue-advanced-cropper/issues/44#issuecomment-648254767
</script>

<template>
  <div>
    <div class="media-picker__selector__viewport">
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

    <div  class="modal show media-picker__cropper" 
          tabindex="-1"
          role="dialog"
          :class="{'d-block': crop.modal}">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{i18n.crop.title}}</h5>
            <button type="button"
                    class="btn-close"
                    @click="cropperClose()">
                  </button>
          </div>
          <div class="modal-body bg-black">
            <cropper
              ref="cropper"
              :canvas="false"
              :check-orientation="false"
              :default-size="cropperSize"
              :minWidth="600"
              :resizeImage="{ wheel: false }"
              :src="blob.url"
              @change="cropperChange"
              />
          </div>
          <div class="modal-footer justify-content-between">
            <button type="button"
                    class="btn btn-sm"
                    aria-label="{{i18n.crop.rotate}}"
                    @click="rotate(90)">
              <i class="bi bi-arrow-clockwise"></i>
            </button>
            <div>
              <button type="button" 
                      class="btn btn-sm btn-secondary me-2"
                      @click="cropperClose()">
                {{i18n.crop.cancel}}
              </button>
              <button type="button"
                      class="btn btn-sm btn-primary"
                      @click="cropperCrop()">
                {{i18n.crop.validate}}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-backdrop show" :class="{'d-none': !crop.modal}"></div>
  </div>
</template>