<script>
import { Crop } from '@lucide/vue';
import { Preview } from 'vue-advanced-cropper';
import logicMixin from './_mixin.js';
import CropperModal from '../CropperModal.vue';

export default {
  name: 'SelectedMedia',
  mixins: [logicMixin],
  components: {
    Crop,
    CropperModal,
    Preview,
  },
  emits: [
    'cropped'
  ],
  props: {
    contextAboutGid: { type: String, default: '' },
    cropSettings: { type: Object, default: () => ({}) },
    cropperButton: { type: Boolean, default: true },
  },
  data() {
    return {
      cropperPreview: null,
      lastEmittedCropSettings: null,
    }
  },
  watch: {
    cropSettings(value) {
      if (JSON.stringify(value) !== JSON.stringify(this.lastEmittedCropSettings)) {
        this.cropperPreview = null;
      }
    },
  },
  computed: {
    previewAspectRatio() {
      const { width, height } = this.cropperPreview.coordinates;
      return `${width} / ${height}`;
    },
    url() {
      let url = this.endpoint + '/' + this.id + '.json';
      if (this.contextAboutGid) {
        url += '?context_about_gid=' + this.contextAboutGid;
      }
      return url;
    },
    src() {
      if (this.resource?.context) {
        return this.resource?.context.thumb;
      } else {
        return this.resource?.media.thumb;
      }
    },
  },
  methods: {
    openCropper() {
      this.$refs.cropper.launch(this.resource?.media.url, this.cropSettings);
    },
    cropped(data, preview) {
      this.lastEmittedCropSettings = data;
      this.cropperPreview = preview;
      this.$emit('cropped', data);
    },
  }
};
</script>

<template>
  <div
    v-if="resource"
    class="position-relative"
    >
    <div
      v-if="cropperButton"
      class="vue__cropper__button"
      @click="openCropper"
      >
      <Crop stroke-width="1.5" />
    </div>
    <div
      v-if="cropperPreview"
      class="vue__cropper__preview"
      :style="{ 'aspect-ratio': previewAspectRatio }"
      >
      <Preview
        fill
        :image="cropperPreview.image"
        :coordinates="cropperPreview.coordinates"
        />
    </div>
    <img
      v-else
      :src="src"
      loading="lazy"
      decoding="async"
      class="img-fluid"
      />
  </div>
  <CropperModal
    ref="cropper"
    @cropped="cropped"
    />
</template>
