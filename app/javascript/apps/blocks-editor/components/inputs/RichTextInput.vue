<script>
// Summernote wrapper. Owns its DOM lifecycle (init on mount, destroy on
// unmount) and bridges editor changes to v-model.
//
// Translation bridge: the underlying <textarea> keeps `data-translatable="true"`
// so translation.js still finds it. After translation.js calls
// `$(field).summernote('code', text)` and dispatches an `input` event on the
// textarea, our `handleTextareaInput` listener re-reads the editor content
// and emits update:modelValue — so the parent v-model picks up translations.

import { useId } from 'vue';

const $ = window.$;

export default {
  name: 'RichTextInput',
  props: {
    modelValue: { type: String, default: '' },
    config: { type: String, default: 'default' },
    placeholder: { type: String, default: '' },
    label: { type: String, default: '' },
  },
  emits: ['update:modelValue'],
  inject: {
    summernoteLocale: { default: null },
  },
  setup() {
    return { fieldId: useId() };
  },
  watch: {
    modelValue(newVal) {
      // Avoid feedback loop with our own onChange callback.
      const current = $(this.$refs.textarea).summernote('code');
      if (current !== (newVal || '')) {
        $(this.$refs.textarea).summernote('code', newVal || '');
      }
    },
  },
  mounted() {
    const textarea = this.$refs.textarea;
    const $textarea = $(textarea);
    const configs = window.SUMMERNOTE_CONFIGS || {};
    const cfg = configs[this.config] || configs.default || { toolbar: [], callbacks: {} };

    const emitChange = (content) => this.$emit('update:modelValue', content);

    const onFocus = function () {
      $(this).parent().children('.note-editor')
        .removeClass('note-editor--defocusing')
        .addClass('note-editor--focus');
    };
    const onBlur = function () {
      const editor = $(this).parent().children('.note-editor');
      editor.addClass('note-editor--defocusing');
      setTimeout(() => {
        const defocusing = editor.hasClass('note-editor--defocusing');
        const codeview = editor.hasClass('codeview');
        if (defocusing && !codeview) editor.removeClass('note-editor--focus');
      }, 1000);
    };
    const onCursor = function (event) {
      const node = event.target.nodeName;
      const $editor = $(this).parent().children('.note-editor');
      const $btn = $editor.find('.note-btn-note');
      if (node === 'NOTE') $btn.addClass('active');
      else $btn.removeClass('active');
    };

    $textarea.summernote({
      lang: this.summernoteLocale,
      toolbar: cfg.toolbar,
      followingToolbar: true,
      disableDragAndDrop: true,
      codemirror: window.codemirrorManager.defaultConfig(),
      buttons: {
        q: window.summernoteManager.qButton,
        note: window.summernoteManager.noteButton,
      },
      callbacks: {
        onPaste: cfg.callbacks?.onPaste,
        onChange: emitChange,
        onChangeCodeview: emitChange,
        onBlur,
        onFocus,
        onMousedown: onCursor,
        onKeydown: onCursor,
      },
    });

    if (this.modelValue) {
      $textarea.summernote('code', this.modelValue);
    }

    textarea.addEventListener('input', this.handleTextareaInput);
  },
  beforeUnmount() {
    const textarea = this.$refs.textarea;
    if (!textarea) return;
    textarea.removeEventListener('input', this.handleTextareaInput);
    try {
      $(textarea).summernote('destroy');
    } catch (_) { /* noop */ }
  },
  methods: {
    handleTextareaInput() {
      // translation.js dispatches `input` on the textarea after pushing a
      // translated value via summernote('code', text). Pick that up and emit
      // upstream so v-model stays consistent.
      const content = $(this.$refs.textarea).summernote('code');
      this.$emit('update:modelValue', content);
    },
  },
};
</script>

<template>
  <div>
    <label v-if="label" class="form-label" :for="fieldId">{{ label }}</label>
    <div class="summernote mb-3">
      <textarea
        ref="textarea"
        :id="fieldId"
        class="form-control summernote-vue"
        data-translatable="true"
        :placeholder="placeholder"></textarea>
      <slot name="hint" />
    </div>
  </div>
</template>
