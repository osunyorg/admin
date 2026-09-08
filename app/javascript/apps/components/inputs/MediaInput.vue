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
    contextAboutGid: { type: String, default: '' },
    cropSettings: { type: Object, default: () => ({}) },
    modelValue: { type: String, default: '' },
    multiple: { type: Boolean, default: false },
    multipleTarget: { type: Array, default: [] },
    objectEndpoint: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
    uploaderHint: { type: String, default: '' },
    uploaderEndpoint: { type: String, required: true },
    uploaderSizeLimit: { type: Number, required: true },
  },
  emits: [
    'update:modelValue',
    'picked',
    'loaded',
    'cropped',
    'unselected',
  ],
  data() {
    return {
      uploadProgress: null,
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
    },
    manage(id) {
      if (this.multiple) {
        this.multipleTarget.push({
          image: {
            communication_media_id: id
          },
          alt: ''
        });
      } else {
        this.value = id;
        this.resetCrop();
      }
    },
    resetCrop() {
      this.$emit('cropped', {});
    },
    uploaded(id) {
      this.manage(id);
    },
    selected(id) {
      this.manage(id);
    },
    picked(object) {
      this.manage(object.id);
      this.$emit('picked', object);
    },
    loaded(data) {
      this.$emit('loaded', data);
      if (data.context) {
        this.$emit('cropped', data.context.crop_settings);
      }
    },
    cropped(data) {
      this.$emit('cropped', data);
    },
    remove() {
      this.value = '';
      this.$emit('cropped', {});
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
        :contextAboutGid="contextAboutGid"
        :cropSettings="cropSettings"
        :endpoint="objectEndpoint"
        @loaded="loaded"
        @cropped="cropped"
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
      <div>
        <MediaUploader
          :accept="accept"
          :endpoint="uploaderEndpoint"
          :hint="uploaderHint"
          :multiple="multiple"
          :size-limit="uploaderSizeLimit"
          @uploaded="uploaded"
          @uploading="uploading"
          />
        <div
          class="d-flex flex-wrap justify-content-between"
          v-if="!isUploading">
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
