<script>
import { createApp } from 'vue';
import { VueDraggableNext } from 'vue-draggable-next';
import { editorFormData, editorFormMethods, ensureDirectUploadProgressListeners } from '../editor-form-runtime';

// Renders the block-edit (or block-new) form fetched from the server inside
// the offcanvas, mounts a fresh Vue app on it for reactive v-model bindings,
// and unmounts on close. Replaces the old iframe-based OffCanvas.vue.
export default {
  props: ['url', 'i18n'],
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
        // edit form root so we don't inject a second <html>/<head> into the
        // current document.
        const doc = new DOMParser().parseFromString(text, 'text/html');
        const root = doc.querySelector('[data-editor-form-root]');
        this.html = root ? root.outerHTML : text;
        await this.$nextTick();
        this.mountInner();
      } finally {
        this.loading = false;
      }
    },

    mountInner() {
      const root = this.$refs.container?.querySelector('[data-editor-form-root]');
      if (!root) return;

      ensureDirectUploadProgressListeners();

      const mode = root.dataset.mode; // 'edit' or 'new'
      const payload = root.dataset.payload ? JSON.parse(root.dataset.payload) : null;

      if (mode === 'edit' && payload) {
        this.innerApp = createApp({
          components: { draggable: VueDraggableNext },
          data() { return editorFormData(payload); },
          methods: editorFormMethods,
          mounted() {
            this.handleSummernotes();
            setTimeout(() => this.handleCodemirrors(), 0);
            document.initLanguageTool?.();
            // The translation singleton hooks into '#translation-button' on
            // DOMContentLoaded, which has long fired by now — re-init it
            // against the freshly-injected libre translate button. Scope it
            // to the form root so we don't bind to the outer page's own
            // translation button (posts/pages/people forms also render one).
            if (this.$el.querySelector('#translation-button')) {
              window.osuny?.translation?.init?.(this.$el);
            }
          },
          updated() {
            this.handleSummernotes();
          },
        });
        this.innerApp.mount(root);
      }

      this.wireForms(root, mode);
      this.wireCancelButtons(root);
      this.wireNewBlockCards(root);
    },

    wireNewBlockCards(root) {
      // In `new` mode, each template card wraps a mini-form. Clicking anywhere
      // on the card (image, title, description) should submit that form. The
      // old approach relied on `js-validate-form-click` initialised on
      // DOMContentLoaded + Bootstrap's `.stretched-link` on the submit button,
      // but DOMContentLoaded has already fired by the time we inject this HTML
      // into the offcanvas, so neither was picking up. We bind imperatively
      // here instead; `requestSubmit()` goes through our existing submit
      // listener wired by `wireForms`.
      root.querySelectorAll('[data-block-card]').forEach((card) => {
        card.style.cursor = 'pointer';
        card.addEventListener('click', (event) => {
          // Let direct clicks on the submit button behave natively.
          if (event.target.closest('[type=submit]')) return;
          const form = card.querySelector('form');
          if (form) form.requestSubmit();
        });
      });
    },

    wireForms(root, mode) {
      // The edit form posts block params; the new page has one form per
      // template kind — both are intercepted to keep the offcanvas alive.
      root.querySelectorAll('form').forEach((form) => {
        form.addEventListener('submit', (event) => this.onSubmit(event, mode));
      });
    },

    wireCancelButtons(root) {
      // Any `.vue__changes__cancel` button inside the form closes the offcanvas.
      root.querySelectorAll('.vue__changes__cancel').forEach((button) => {
        button.addEventListener('click', (event) => {
          event.preventDefault();
          this.$emit('close');
        });
      });
    },

    async onSubmit(event, mode) {
      event.preventDefault();
      const form = event.target;
      const submit = form.querySelector('[type=submit]');
      if (submit) submit.disabled = true;

      const res = await fetch(form.action, {
        method: form.method.toUpperCase(),
        body: new FormData(form),
        headers: { Accept: 'text/javascript' },
      });

      if (res.status === 201 && mode === 'new') {
        // Block was just created — navigate the offcanvas to its edit URL.
        const location = res.headers.get('Location');
        if (location) {
          this.$emit('navigate', location);
          await this.load(location);
        }
        return;
      }

      if (res.ok) {
        this.$emit('save');
        return;
      }

      // Re-enable submit on error so the user can retry.
      if (submit) submit.disabled = false;
      if (res.status === 422) {
        // Reload the form (server re-rendered with errors).
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
  <section>
    <div
      class="offcanvas offcanvas-end vue__blocks-editor__offcanvas"
      :class="{ show: url }"
      tabindex="-1">
      <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title">{{ i18n.blocksEditor.offcanvas.title }}</h5>
        <button
          type="button"
          class="btn-close"
          @click="$emit('close')"
          :aria-label="i18n.blocksEditor.offcanvas.close"></button>
      </div>
      <div class="offcanvas-body">
        <div v-if="loading && !html" class="text-center py-5">
          <div class="spinner-border text-primary" role="status" />
        </div>
        <div ref="container" v-html="html" />
      </div>
    </div>
    <div
      v-show="url"
      @click="$emit('close')"
      class="offcanvas-backdrop"
      :class="{ show: url }"></div>
  </section>
</template>
