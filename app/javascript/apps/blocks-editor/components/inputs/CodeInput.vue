<script>
// CodeMirror wrapper. Owns its DOM lifecycle (fromTextArea on mount,
// toTextArea on unmount) and bridges editor changes to v-model.
//
// Not translatable — code blocks (HTML, SVG, CSS snippets) shouldn't go
// through LibreTranslate, so the textarea does NOT carry data-translatable.

import { useId } from 'vue';

export default {
  name: 'CodeInput',
  props: {
    modelValue: { type: String, default: '' },
    placeholder: { type: String, default: '' },
    label: { type: String, default: '' },
  },
  emits: ['update:modelValue'],
  setup() {
    return { fieldId: useId() };
  },
  data() {
    return { editor: null };
  },
  watch: {
    modelValue(newVal) {
      if (!this.editor) return;
      if (this.editor.getValue() !== (newVal || '')) {
        this.editor.setValue(newVal || '');
      }
    },
  },
  mounted() {
    const config = window.codemirrorManager.defaultConfig();
    config.mode = 'htmlmixed';
    this.editor = window.CodeMirror.fromTextArea(this.$refs.textarea, config);
    this.editor.setValue(this.modelValue || '');
    this.editor.on('change', (instance) => {
      this.$emit('update:modelValue', instance.getValue());
    });
  },
  beforeUnmount() {
    if (this.editor) {
      this.editor.toTextArea();
      this.editor = null;
    }
  },
};
</script>

<template>
  <div>
    <label v-if="label" class="form-label" :for="fieldId">{{ label }}</label>
    <textarea
      ref="textarea"
      :id="fieldId"
      class="form-control mb-3 codemirror-vue"
      :placeholder="placeholder"></textarea>
  </div>
</template>