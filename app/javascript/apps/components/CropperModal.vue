<script>
import { Cropper } from 'vue-advanced-cropper';

export default {
  components: {
    Cropper,
  },
  emits: [
    'cropped',
  ],
  data() {
    return {
      modalOpened: false,
      url: '',
      loading: true,
      data: {
        height: null,
        left: null,
        rotation: 0,
        top: null,
        width: null,
      },
      preview: null,
    }
  },
  methods: {
    launch(url, data) {
      this.url = url;
      this.data = data;
      this.preview = null;
      this.loading = true;
      this.modalOpened = true;
    },
    close() {
      this.modalOpened = false;
    },
    ready() {
      this.loading = false;
      if (this.data.width && this.data.height) {
        this.$refs.cropper.setCoordinates({
          height: this.data.height,
          left: this.data.left,
          top: this.data.top,
          width: this.data.width,
        }, { transitions: false });
      }
      if (this.data.rotation) {
        this.$refs.cropper.rotate(this.data.rotation, { transitions: false });
      }
    },
    rotate(angle) {
      this.$refs.cropper.rotate(angle);
    },
    reset() {
      this.$refs.cropper.reset();
    },
		defaultSize({ imageSize, visibleArea }) {
			return {
				width: (visibleArea || imageSize).width,
				height: (visibleArea || imageSize).height,
			};
		},
    extractDataFromCropper() {
      const image = this.$refs.cropper.image;
      const imageTransforms = this.$refs.cropper.imageTransforms;
      const coordinates = this.$refs.cropper.coordinates;
      this.data.height = Math.round(coordinates.height);
      this.data.left = Math.round(coordinates.left);
      this.data.rotation = Math.round(imageTransforms.rotate);
      this.data.top = Math.round(coordinates.top);
      this.data.width = Math.round(coordinates.width);
      this.preview = {
        coordinates: coordinates,
        image: image,
      };
    },
    confirm() {
      this.extractDataFromCropper();
      this.$emit('cropped', this.data, this.preview);
      this.close();
    },
  },
};
// On utilise canvas=false et check-orientation=false pour éviter les problèmes de CORS
// https://github.com/advanced-cropper/vue-advanced-cropper/issues/44#issuecomment-648254767
</script>

<template>
  <div>
    <div
      class="modal vue__cropper"
      tabindex="-1"
      role="dialog"
      :class="{'d-block': modalOpened}"
      >
      <div class="modal-dialog modal-fullscreen">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ $t('components.cropperModal.title') }}</h5>
            <button
              type="button"
              class="btn-close"
              @click="close"
              >
            </button>
          </div>
          <div class="modal-body">
            <Cropper
              ref="cropper"
              :canvas="false"
              :check-orientation="false"
              :default-size="defaultSize"
              :minWidth="600"
              :resizeImage="{ wheel: false }"
              :src="url"
              @ready="ready"
              />
            <div
              class="position-absolute top-50 end-50"
              v-if="loading"
              >
              <span class="spinner-border text-white" role="status"></span>
            </div>
          </div>
          <div class="modal-footer justify-content-between">
            <div>
              <button
                type="button"
                class="btn btn-sm"
                :aria-label="$t('components.cropperModal.rotate')"
                @click="rotate(90)"
                >
                <i class="bi bi-arrow-clockwise"></i>
                {{ $t('components.cropperModal.rotate') }}
              </button>
              <button
                type="button"
                class="btn btn-sm"
                :aria-label="$t('components.cropperModal.rotate')"
                @click="reset"
                >
                <i class="bi bi-arrows-fullscreen"></i>
                {{ $t('components.cropperModal.reset') }}
              </button>
            </div>
            <div>
              <button
                type="button"
                class="btn btn-sm btn-secondary me-2"
                @click="close"
                >
                {{ $t('components.cropperModal.cancel') }}
              </button>
              <button
                type="button"
                class="btn btn-sm btn-primary"
                @click="confirm"
                >
                {{ $t('components.cropperModal.validate') }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
