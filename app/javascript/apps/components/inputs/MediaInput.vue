<script>
import Cloud from './media-input/Cloud.vue';
import ImageUploader from './media-input/ImageUploader.vue';
import SelectedMedia from '../selected-objects/SelectedMedia.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'MediaInput',
  components: {
    Cloud, 
    ImageUploader,
    SelectedMedia,
    Picker
  },
  props: {
    modelValue: { type: String, default: '' },
    accept: { type: String, default: '*' },
    objectEndpoint: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
    pickerLabel: { type: String, required: true },
    pickerTitle: { type: String, required: true },
    sizeLimit: { type: [String, Number], default: null },
  },
  emits: [
    'update:modelValue',
    'mediaSelected'
  ],
  data() {
    return {
      uploadProgress: null,
    };
  },
  computed: {
    value: {
      get() {
        return this.modelValue
      },
      set(value) {
        this.$emit('update:modelValue', value)
      }
    },
    hasValue() {
      return this.modelValue != '';
    },
    isUploading() {
      return this.uploadProgress !== null;
    },
  },
  methods: {
      uploaded(blob) {
        this.current.origin.blob = blob;
        this.current.image.url = this.current.origin.blob.url;
      },
      unsplashSelected(image) {
        this.current.origin.cloud.unsplash.id = image.id;
        this.current.origin.cloud.unsplash.url = image.preview;
        this.current.image.credit = image.credit;
        this.current.image.url = image.preview;
      },
      pexelsSelected(image) {
        this.current.origin.cloud.pexels.id = image.id;
        this.current.origin.cloud.pexels.url = image.preview;
        this.current.image.credit = image.credit;
        this.current.image.url = image.preview;
      },
      mediaSelected(media) {
        this.$emit('update:modelValue', media.id);
        this.$emit('mediaSelected', media);
      }
  },
};
</script>

<template>
  <div style="min-height: 50px">
    <SelectedMedia
      v-if="hasValue"
      :id="value"
      :endpoint="objectEndpoint" />
    <div v-else>
      <progress
        v-show="isUploading"
        class="mt-2"
        :value="uploadProgress"
        max="100"
        style="width: 100%;" />
      <ImageUploader @uploaded="uploaded" />
      <div class="d-flex flex-wrap justify-content-between">
        <Cloud
          @unsplashSelected="unsplashSelected"
          @pexelsSelected="pexelsSelected" />
        <Picker
          :endpoint="pickerEndpoint"
          @picked="mediaSelected"
          :label="pickerLabel"
          :title="pickerTitle"
          :accept="accept" />
      </div>
    </div>
  </div>
</template>
