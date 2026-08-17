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
    uploadEndpoint: { type: String, required: true },
    cloudSelectEndpoint: { type: String, required: true },
    objectEndpoint: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
    pickerLabel: { type: String, required: true },
    pickerTitle: { type: String, required: true },
    sizeLimit: { type: [String, Number], default: null },
  },
  emits: [
    'update:modelValue',
    'mediaLoaded',
  ],
  data() {
    return {
      uploadProgress: null
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
    mediaSelected(mediaId) {
      this.$emit('update:modelValue', mediaId);
    },
    selectionFromPicker(media) {
      this.mediaSelected(media.id);
    },
    mediaLoaded(data) {
      this.$emit('mediaLoaded', data);
    }
  },
};
</script>

<template>
  <div style="min-height: 50px">
    <SelectedMedia
      v-if="hasValue"
      :id="value"
      @loaded="mediaLoaded"
      :endpoint="objectEndpoint" />
    <div v-else>
      <progress
        v-show="isUploading"
        class="mt-2"
        :value="uploadProgress"
        max="100"
        style="width: 100%;" />
      <ImageUploader
        :endpoint="uploadEndpoint"
        @uploaded="mediaSelected" />
      <div class="d-flex flex-wrap justify-content-between">
        <Cloud
          :endpoint="cloudSelectEndpoint"
          @selected="mediaSelected" />
        <Picker
          :endpoint="pickerEndpoint"
          @picked="selectionFromPicker"
          :label="pickerLabel"
          :title="pickerTitle"
          :accept="accept" />
      </div>
    </div>
  </div>
</template>
