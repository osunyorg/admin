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
    uploadHint: { type: String, default: '' },
    uploadEndpoint: { type: String, required: true },
    cloudQuery: { type: String, required: true },
    cloudUnsplashEndpoint: { type: String, required: true },
    cloudPexelsEndpoint: { type: String, required: true },
    cloudSelectEndpoint: { type: String, required: true },
    objectEndpoint: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
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
    },
    remove() {
      this.$emit('update:modelValue', '');
    },
  },
};
</script>

<template>
  <div style="min-height: 50px">
    <div class="d-lg-flex me-4 mb-0">
      <label class="form-label">
        {{ $t('components.inputs.mediaInput.title') }}
      </label>
    </div>
    <div v-if="hasValue">
      <SelectedMedia
        :id="value"
        @loaded="mediaLoaded"
        :endpoint="objectEndpoint" />
      <div class="text-end">
        <a  class="btn btn-sm text-danger pe-0"
            @click="remove">
          <i class="<%= Icon::DELETE %>"></i>
          {{ $t('components.inputs.mediaInput.remove') }}
        </a>
      </div>
    </div>
    <div v-else>
      <progress
        v-show="isUploading"
        class="mt-2"
        :value="uploadProgress"
        max="100"
        style="width: 100%;" />
      <ImageUploader
        :endpoint="uploadEndpoint"
        :accept="accept"
        :hint="uploadHint"
        @uploaded="mediaSelected" />
      <div class="d-flex flex-wrap justify-content-between">
        <Cloud
          :query="cloudQuery"
          :unsplash-endpoint="cloudUnsplashEndpoint"
          :pexels-endpoint="cloudPexelsEndpoint"
          :select-endpoint="cloudSelectEndpoint"
          @selected="mediaSelected" />
        <Picker
          :endpoint="pickerEndpoint"
          @picked="selectionFromPicker"
          :label="$t('components.inputs.mediaInput.picker.button')"
          :title="$t('components.inputs.mediaInput.picker.title')"
          :accept="accept" />
      </div>
    </div>
  </div>
</template>
