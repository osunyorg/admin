<script>
import Cloud from './media-input/Cloud.vue';
import MediaUploader from './media-input/MediaUploader.vue';
import Picker from '../../picker/Picker.vue';
import SelectedMedia from '../selected-objects/SelectedMedia.vue';

export default {
  name: 'MediaInput',
  components: {
    Cloud, 
    MediaUploader,
    Picker,
    SelectedMedia,
  },
  props: {
    accept: { type: String, default: '*' },
    cloudDefaultQuery: { type: String, default: '' },
    cloudUnsplashEndpoint: { type: String, required: true },
    cloudPexelsEndpoint: { type: String, required: true },
    cloudSelectEndpoint: { type: String, required: true },
    modelValue: { type: String, default: '' },
    objectEndpoint: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
    uploaderHint: { type: String, default: '' },
    uploaderEndpoint: { type: String, required: true },
    uploaderSizeLimit: { type: Number, required: true },
  },
  emits: [
    'update:modelValue',
    'uploading',
    'loaded',
    'unselected',
  ],
  data() {
    return {
      uploadProgress: null
    };
  },
  computed: {
    value: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
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
    uploading(percent) {
      this.uploadProgress = percent;
      this.$emit('uploading', percent);
    },
    uploaded(id) {
      this.value = id;
    },
    selected(id) {
      this.value = id;
    },
    picked(object) {
      this.value = object.id;
    },
    loaded(data) {
      this.$emit('loaded', data);
    },
    remove() {
      this.value = '';
      this.$emit('unselected');
    },
  },
};
</script>

<template>
  <div class="mb-4">
    <div class="d-lg-flex me-4 mb-0">
      <label class="form-label">
        {{ $t('components.inputs.mediaInput.title') }}
      </label>
    </div>
    <div v-if="hasValue">
      <SelectedMedia
        :id="value"
        :endpoint="objectEndpoint"
        @loaded="loaded"
        />
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
        class="mt-2"
        max="100"
        style="width: 100%;"
        :value="uploadProgress"
        v-show="isUploading"
        />
      <div v-show="!isUploading">
        <MediaUploader
          :accept="accept"
          :endpoint="uploaderEndpoint"
          :hint="uploaderHint"
          :size-limit="uploaderSizeLimit"
          @uploaded="uploaded"
          @uploading="uploading"
          />
        <div class="d-flex flex-wrap justify-content-between">
          <Cloud
            :default-query="cloudDefaultQuery"
            :pexels-endpoint="cloudPexelsEndpoint"
            :select-endpoint="cloudSelectEndpoint"
            :unsplash-endpoint="cloudUnsplashEndpoint"
            @selected="selected"
            />
          <Picker
            :accept="accept"
            :endpoint="pickerEndpoint"
            :label="$t('components.inputs.mediaInput.picker.button')"
            :title="$t('components.inputs.mediaInput.picker.title')"
            @picked="picked"
            />
        </div>
      </div>
    </div>
  </div>
</template>
