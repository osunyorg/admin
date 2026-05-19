<script>
import { createApp, provide, reactive } from 'vue';
import { VueDraggableNext } from 'vue-draggable-next';
import RichTextInput from './inputs/RichTextInput.vue';
import CodeInput from './inputs/CodeInput.vue';
import UploadInput from './inputs/UploadInput.vue';
import MultiImageInput from './inputs/MultiImageInput.vue';

// Renders the block-edit form fetched from the server, mounts a fresh inner
// Vue app on it for reactive v-model bindings, and unmounts on close. The
// outer offcanvas chrome lives in OffcanvasShell.vue; we only render the
// form content here.
//
// The inner app exposes a small reactive surface (data, addElement,
// deleteElement, getImageUrl) for the ERB-rendered templates, and registers
// 4 wrapper components (RichTextInput, CodeInput, UploadInput,
// MultiImageInput) that each own their own DOM lifecycle.

export default {
  name: 'Editor',
  props: {
    url: { type: String, required: true },
  },
  emits: ['save', 'close'],
  data() {
    return {
      html: null,
      loading: false,
      innerApp: null,
    };
  },
  watch: {
    url: {
      handler(newUrl) {
        if (newUrl) this.load(newUrl);
        else this.cleanup();
      },
      immediate: true,
    },
  },
  beforeUnmount() {
    this.cleanup();
  },
  methods: {
    async load(url) {
      this.cleanup();
      this.loading = true;
      try {
        const res = await fetch(url, { headers: { Accept: 'text/html' } });
        const text = await res.text();
        // Server returns the `raw` layout (full <html> doc). Extract just the
        // [data-editor-form-root] subtree so we don't inject a second
        // <html>/<head> into the current document.
        const doc = new DOMParser().parseFromString(text, 'text/html');
        const root = doc.querySelector('[data-editor-form-root]');
        this.html = root ? root.outerHTML : '';
        await this.$nextTick();
        this.mountInner();
      } finally {
        this.loading = false;
      }
    },

    mountInner() {
      const container = this.$refs.container;
      if (!container) return;
      const root = container.querySelector('[data-editor-form-root]');
      if (!root) return;

      // Vue mount has to happen BEFORE wiring DOM listeners: createApp.mount()
      // takes the element's innerHTML as its template, compiles it, then
      // replaces the element's children with the rendered output — any
      // listener attached beforehand would be discarded with the old DOM.
      this.mountVueApp(root);
      this.wireForms(root);
      this.wireCancelButtons(root);
    },

    mountVueApp(root) {
      const payload = JSON.parse(root.dataset.payload);
      this.innerApp = createApp({
        setup() {
          // Reactive state + helpers exposed to the server-rendered Vue
          // templates inside this block's edit form. The templates reference
          // `data.title`, `data.elements`, `addElement()`, `deleteElement()`,
          // `getImageUrl()`, `defaultElement` at top-level scope.
          const data = reactive(payload.data);
          const defaultElement = payload.defaultElement;
          const directUpload = {
            url: payload.directUploadUrl,
            blobUrlTemplate: payload.blobUrlTemplate,
          };

          function deleteElement(element) {
            const index = data.elements.indexOf(element);
            if (index >= 0) data.elements.splice(index, 1);
          }
          function addElement() {
            data.elements.push(JSON.parse(JSON.stringify(defaultElement)));
          }
          function getImageUrl(image) {
            if (!image?.signed_id) return '';
            const parts = image.filename.split('.');
            const extension = parts[parts.length - 1];
            // Substitute :signed_id and :filename in the blob URL template
            // we got from the server (medium_url helper, see edit.html.erb).
            return directUpload.blobUrlTemplate
              .replace(':signed_id', image.signed_id)
              .replace(':filename', `image_1024x.${extension}`);
          }

          // The input wrappers reach for these via inject() instead of
          // prop-drilling them through every server-rendered partial.
          provide('directUpload', directUpload);
          provide('getImageUrl', getImageUrl);
          provide('summernoteLocale', payload.summernoteLocale);

          return { data, defaultElement, deleteElement, addElement, getImageUrl };
        },
        mounted() {
          // LanguageTool is a singleton initialised on DOMContentLoaded that
          // exposes `document.initLanguageTool` for re-binding after AJAX
          // updates — we call it here so the freshly-injected form picks up
          // grammar checking.
          document.initLanguageTool?.();
          // Same pattern for the translation singleton: it hooks into
          // '#translation-button' on DOMContentLoaded and we need to re-init
          // it against the button inside the offcanvas. Scope it to this
          // form's root so we don't bind to the outer page's own libre
          // translate button (posts/pages/people forms also render one).
          if (this.$el.querySelector('#translation-button')) {
            window.osuny?.translation?.init?.(this.$el);
          }
        },
      });

      this.innerApp.component('draggable', VueDraggableNext);
      this.innerApp.component('RichTextInput', RichTextInput);
      this.innerApp.component('CodeInput', CodeInput);
      this.innerApp.component('UploadInput', UploadInput);
      this.innerApp.component('MultiImageInput', MultiImageInput);

      this.innerApp.mount(root);
    },

    wireForms(root) {
      root.querySelectorAll('form').forEach((form) => {
        form.addEventListener('submit', (event) => this.onSubmit(event));
      });
    },

    wireCancelButtons(root) {
      // The `.vue__changes__cancel` button closes the offcanvas.
      root.querySelectorAll('.vue__changes__cancel').forEach((button) => {
        button.addEventListener('click', (event) => {
          event.preventDefault();
          this.$emit('close');
        });
      });
    },

    async onSubmit(event) {
      event.preventDefault();
      const form = event.target;
      const submit = form.querySelector('[type=submit]');
      if (submit) submit.disabled = true;

      const res = await fetch(form.action, {
        method: form.method.toUpperCase(),
        body: new FormData(form),
        headers: { Accept: 'text/javascript' },
      });

      if (res.ok) {
        this.$emit('save');
        return;
      }

      // Re-enable submit on error so the user can retry.
      if (submit) submit.disabled = false;
      if (res.status === 422) {
        // Server re-rendered the form with errors — swap it in and re-mount.
        const text = await res.text();
        const doc = new DOMParser().parseFromString(text, 'text/html');
        const fresh = doc.querySelector('[data-editor-form-root]');
        if (fresh) {
          this.cleanup();
          this.html = fresh.outerHTML;
          await this.$nextTick();
          this.mountInner();
        }
      }
    },

    cleanup() {
      if (this.innerApp) {
        try { this.innerApp.unmount(); } catch (_) { /* noop */ }
        this.innerApp = null;
      }
      this.html = null;
    },
  },
};
</script>

<template>
  <div>
    <div v-if="loading && !html" class="text-center py-5">
      <div class="spinner-border text-primary" role="status" />
    </div>
    <div ref="container" v-html="html" />
  </div>
</template>
