<script>
import { useId } from 'vue';

// Single file upload + preview + remove. The `kind` prop switches the post-
// upload preview — image kind shows an <img> via the injected `getImageUrl`,
// file kind shows the filename. The bound value is the blob descriptor
// `{ id, signed_id, filename }`, which round-trips into the block's data
// column.

export default {
  name: 'UploadInput',
  props: {
    modelValue: { type: Object, default: () => ({}) },
    kind: {
      type: String,
      default: 'file',
      validator: (v) => ['image', 'file'].includes(v),
    },
    label: { type: String, default: '' },
    remove: { type: String, default: '' },
    hint: { type: String, default: '' },
    accept: { type: String, default: '*' },
    sizeLimit: { type: [String, Number], default: null },
  },
  emits: ['update:modelValue'],
  inject: {
    directUpload: { from: 'directUpload' },
    getImageUrl: { from: 'getImageUrl', default: null },
  },
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
      return Boolean(this.modelValue?.id);
    },
    effectiveSizeLimit() {
      // The ERB partials always pass an explicit limit; the fallback is just
      // a safety net for unexpected callsites.
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

      const onProgressUpdate = (pct) => { this.progress = pct; };
      const delegate = {
        directUploadWillStoreFileWithXHR(xhr) {
          xhr.upload.addEventListener('progress', (event) => {
            if (event.total) onProgressUpdate((event.loaded / event.total) * 100);
          });
        },
      };

      new window.ActiveStorage.DirectUpload(file, this.directUpload.url, delegate).create(
        (error, blob) => {
          this.uploading = false;
          if (error) {
            // eslint-disable-next-line no-console
            console.error(error);
            return;
          }
          this.$emit('update:modelValue', {
            id: blob.id,
            signed_id: blob.signed_id,
            filename: blob.filename,
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
      <img v-if="kind === 'image'" :src="getImageUrl(modelValue)" class="img-fluid mb-3" />
      <p v-else><b>{{ modelValue.filename }}</b></p>
      <a class="btn btn-sm text-danger" @click="clear">
        <i class="fas fa-times"></i>
        {{ remove }}
      </a>
    </template>
  </div>
</template>
