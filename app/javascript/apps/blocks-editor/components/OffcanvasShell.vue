<script>
// Generic right-aligned offcanvas chrome. Owns the show/hide state, a header
// strip (title + close button), a body slot for the content, and the
// backdrop. Locks body scroll while open via Bootstrap's `modal-open` class.

export default {
  name: 'OffcanvasShell',
  props: {
    open: { type: Boolean, default: false },
    title: { type: String, default: '' },
    closeLabel: { type: String, default: '' },
  },
  emits: ['close'],
  watch: {
    open: {
      handler(isOpen) {
        document.body.classList.toggle('modal-open', isOpen);
      },
      immediate: true,
    },
  },
  beforeUnmount() {
    document.body.classList.remove('modal-open');
  },
};
</script>

<template>
  <section>
    <div
      class="offcanvas offcanvas-end vue__blocks-editor__offcanvas"
      :class="{ show: open }"
      tabindex="-1">
      <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title">{{ title }}</h5>
        <button
          type="button"
          class="btn-close"
          @click="$emit('close')"
          :aria-label="closeLabel"></button>
      </div>
      <div class="offcanvas-body p-0">
        <slot />
      </div>
    </div>
    <div
      v-show="open"
      @click="$emit('close')"
      class="offcanvas-backdrop"
      :class="{ show: open }"></div>
  </section>
</template>
