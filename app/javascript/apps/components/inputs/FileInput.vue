<script>
import FileUploader from './file-input/FileUploader.vue';
import Picker from '../../picker/Picker.vue';
import SelectedFile from '../selected-objects/SelectedFile.vue';

export default {
  name: 'FileInput',
  components: {
    FileUploader,
    Picker,
    SelectedFile,
  },
  props: {
    accept: { type: String, default: '*' },
    modelValue: { type: String, default: '' },
    objectEndpoint: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
    pickerLabel: { type: String, default: '' },
    pickerTitle: { type: String, required: true },
    uploaderEndpoint: { type: String, required: true },
    uploaderSizeLimit: { type: Number, required: true },
  },
  emits: [
    'update:modelValue',
    'uploading',
    'loaded',
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
      this.$emit('uploading', percent);
    },
    uploaded(id) {
      this.value = id;
    },
    picked(object) {
      this.value = object.id;
    },
    loaded(data) {
      this.$emit('loaded', data);
    },
  },
};
</script>

<template>
  <div style="min-height: 50px">
    <SelectedFile
      v-if="hasValue"
      :id="value"
      :endpoint="objectEndpoint"
      @loaded="loaded"
      />
    <div v-else>
      <progress
        class="mt-2"
        max="100"
        style="width: 100%;"
        :value="uploadProgress"
        v-show="isUploading"
        />
      <div 
        v-show="!isUploading"
        class="d-flex flex-wrap justify-content-between"
        >
        <FileUploader
          :accept="accept"
          :endpoint="uploaderEndpoint"
          :size-limit="uploaderSizeLimit"
          @uploaded="uploaded"
          @uploading="uploading"
          />
        <Picker
          :accept="accept"
          :endpoint="pickerEndpoint"
          :label="pickerLabel"
          :title="pickerTitle"
          @picked="picked"
          />
      </div>
    </div>
  </div>
</template>
