<script>
export default {
    props: [
      'i18n',
      'url',
    ],
    emits: ['close'],
    methods: {
      onClose(event) {
        event.preventDefault();
        this.$emit('close');
      },
    }
};
</script>

<template>
  <section>
    <div
      class="offcanvas offcanvas-end vue__blocks-editor__offcanvas"
      :class="{'show': url}"
      tabindex="-1">
      <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title">{{ i18n.blocksEditor.offcanvas.title }}</h5>
        <button
          type="button"
          class="btn-close"
          @click="onClose"
          aria-label="{{ i18n.blocksEditor.offcanvas.close }}"></button>
      </div>
      <iframe
        class="vue__blocks-editor__offcanvas__iframe"
        name="editor"
        :src="url"></iframe>
    </div>
    <div
      v-show="url"
      @click="onClose"
      class="offcanvas-backdrop"
      :class="{'show': url}"></div>
  </section>
</template>
