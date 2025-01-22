<script>
import { Cropper } from 'vue-advanced-cropper';

export default {
    components: {
      Cropper,
    },
    data () {
      return {
        modal: false,
        endpoint: "/media/resize/", // signed_id will be added
        pending: false,
        blob: {
          id: null,
          signed_id: null,
          checksum: null,
          url: null
        },
        data: {
          rotation: 0,
          left: null,
          top: null,
          width: null,
          height: null,
        },
        i18n: {},
      }
    },
    methods: {
      launch(blob) {
        this.blob = blob;
        this.modal = true;
      },
      open() {
        this.modal = true;
        document.body.classList.add("modal-open");
      },
      close() {
        this.modal = false;
        document.body.classList.remove("modal-open");
      },
      defaultSize({ imageSize }) {
        return {
          width: imageSize.width,
          height: imageSize.height,
        };
      },
      change({ coordinates }) {
        this.data.left = coordinates.left;
        this.data.top = coordinates.top;
        this.data.width = coordinates.width;
        this.data.height = coordinates.height;
      },
      rotate(angle) {
        this.data.rotation += angle;
        this.$refs.cropper.rotate(angle);
      },
      crop() {
        let xhr = new XMLHttpRequest();
        let url = this.endpoint + this.blob.signed_id;
        xhr.open("POST", url, true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('X-CSRF-Token', document.querySelector('[name="csrf-token"]').content);
        xhr.onreadystatechange = function () {
          if (xhr.readyState != 4) return;
          if (xhr.status == 200) {
            let blob = JSON.parse(xhr.responseText); 
            this.$emit('cropped', blob);
            this.pending = false;
            this.close();
          }
        }.bind(this);
        this.pending = true;
        xhr.send(JSON.stringify(this.data));
      },
    },
    beforeMount() {
      this.i18n = JSON.parse(document.getElementById('media-picker-app').dataset.i18n).cropper;
    },
};

// On utilise canvas=false et check-orientation=false pour éviter les problèmes de CORS
// https://github.com/advanced-cropper/vue-advanced-cropper/issues/44#issuecomment-648254767

</script>

<template>
  <div>
    <div  class="modal show vue__cropper" 
          tabindex="-1"
          role="dialog"
          :class="{'d-block': modal}">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{i18n.title}}</h5>
            <button type="button"
                    class="btn-close"
                    @click="close()">
                  </button>
          </div>
          <div class="modal-body bg-black">
            <Cropper
              ref="cropper"
              :canvas="false"
              :check-orientation="false"
              :default-size="defaultSize"
              :minWidth="600"
              :resizeImage="{ wheel: false }"
              :src="blob.url"
              @change="change"
              />
          </div>
          <div class="modal-footer justify-content-between">
            <button type="button"
                    class="btn btn-sm"
                    :aria-label="i18n.rotate"
                    @click="rotate(90)">
              <i class="bi bi-arrow-clockwise"></i>
            </button>
            <div>
              <button type="button" 
                      class="btn btn-sm btn-secondary me-2"
                      :disabled="pending"
                      @click="close()">
                {{ i18n.cancel }}
              </button>
              <button type="button"
                      class="btn btn-sm btn-primary"
                      :disabled="pending"
                      @click="crop()">
                {{ i18n.validate }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-backdrop show" :class="{'d-none': !modal}"></div>
  </div>
</template>
