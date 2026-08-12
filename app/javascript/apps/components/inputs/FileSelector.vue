<script>
import UploadButton from './primitives/UploadButton.vue';
import SelectedFile from './primitives/SelectedFile.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'FileSelector',
  components: { UploadButton, SelectedFile, Picker },
  props: {
    // Le modèle est un objet composite, pour gérer la migration facilement
    modelValue: { type: Object, default: () => ({}) },
    uploadUrl: { type: String, required: true },
    pickerEndpoint: { type: String, required: true },
    objectEndpoint: { type: String, required: true },
    sizeLimit: { type: [String, Number], default: null },
    label: { type: String, required: true },
    title: { type: String, required: true },
  },
  emits: ['update:modelValue'],
  data() {
    return {
      uploadProgress: null,
    };
  },
  computed: {
    hasValue() {
      return Boolean(this.modelValue?.communication_file_id);
    },
    isUploading() {
      return this.uploadProgress !== null;
    },
  },
  methods: {
    clear() {
      this.$emit('update:modelValue', {});
    },
  },
};
</script>

<template>
  <div style="min-height: 50px">
    <SelectedFile
      v-if="hasValue"
      :id="modelValue.communication_file_id"
      :endpoint="objectEndpoint" />
    <template v-else>
      <progress
        v-show="isUploading"
        class="mt-2"
        :value="uploadProgress"
        max="100"
        style="width: 100%;" />
      <div v-show="!isUploading" class="row">
        <div class="col-md-6">
          <UploadButton
            :model-value="modelValue"
            @update:model-value="$emit('update:modelValue', $event)"
            @uploading="uploadProgress = $event"
            :upload-url="uploadUrl"
            :size-limit="sizeLimit" />
        </div>
        <div class="col-md-6">
          <Picker
            :model-value="modelValue"
            @update:model-value="$emit('update:modelValue', $event)"
            kind="files"
            :label="label"
            :title="title"
            :endpoint="pickerEndpoint" />
        </div>
      </div>
    </template>
  </div>
</template>
