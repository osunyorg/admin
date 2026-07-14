<script>
import { useId } from 'vue';

export default {
  name: 'FileUploadInput',
  props: {
    modelValue: { type: Object, default: () => ({}) },
    uploadUrl: { type: String, required: true },
    label: { type: String, default: '' },
    remove: { type: String, default: '' },
    hint: { type: String, default: '' },
    accept: { type: String, default: '*' },
    sizeLimit: { type: [String, Number], default: null },
  },
  emits: ['update:modelValue'],
  setup() {
    return { fieldId: useId() };
  },
  data() {
    return {
      uploading: false,
      progress: 0,
    };
  },
  computed: {
    hasValue() {
      return Boolean(this.modelValue?.communication_file_id);
    },
    effectiveSizeLimit() {
      return parseInt(this.sizeLimit, 10) || (10 * 1024 * 1024);
    },
  },
  methods: {
    onChange(event) {
      const file = event.target.files?.[0];
      if (!file) return;
      this.upload(file);
    },
    upload(file) {
      if (file.size > this.effectiveSizeLimit) {
        const sizeMo = Math.round(file.size / 1024 / 1024);
        const limitMo = Math.round(this.effectiveSizeLimit / 1024 / 1024);
        // eslint-disable-next-line no-alert
        alert(`File is too big (${sizeMo} Mo > ${limitMo} Mo)`);
        return;
      }

      this.uploading = true;
      this.progress = 0;

      const onProgressUpdate = (percent) => { this.progress = percent; };
      const delegate = {
        directUploadWillStoreFileWithXHR(xhr) {
          xhr.upload.addEventListener('progress', (event) => {
            if (event.total) {
              onProgressUpdate((event.loaded / event.total) * 100);
            }
          });
        },
      };

      new window.ActiveStorage.DirectUpload(file, this.uploadUrl, delegate).create(
        (error, data) => {
          this.uploading = false;
          if (error) {
            // eslint-disable-next-line no-console
            console.error(error);
            return;
          }
          this.$emit('update:modelValue', {
            communication_file_id: data.file.id,
            communication_file_name: data.file.name,
            filename: data.file.filename,
          });
        },
      );
    },
    clear() {
      this.$emit('update:modelValue', {});
    },
  },
};
</script>

<template>
  <div class="mb-3">
    <template v-if="!hasValue">
      <label class="form-label" :for="fieldId">{{ label }}</label>
      <input
        type="file"
        class="form-control"
        :accept="accept"
        :id="fieldId"
        @change="onChange" />
      <progress v-if="uploading" :value="progress" max="100" style="width: 100%;"></progress>
      <div v-if="hint" class="form-text" v-html="hint"></div>
    </template>
    <template v-else>
      <p><b>{{ modelValue.filename }}</b></p>
      <a class="btn btn-sm text-danger" @click="clear">
        <i class="fas fa-times"></i>
        {{ remove }}
      </a>
    </template>
  </div>
</template>
