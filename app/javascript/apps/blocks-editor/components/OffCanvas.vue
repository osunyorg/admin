<script>
export default {
    props: {
      title: { type: String, required: true },
      close: { type: String, required: true },
      url: { type: String },
    },
    methods: {
      closeOffCanvas() {
        this.$emit("closeOffCanvas");
      },
    }
};
</script>

<template>
  <section>
    <div
      class="offcanvas offcanvas-end content-editor__offcanvas"
      :class="{'show': url}"
      tabindex="-1">
      <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title">{{ title }}</h5>
        <button
          type="button"
          class="btn-close"
          @click="closeOffCanvas"
          aria-label="{{ close }}"></button>
      </div>
      <iframe
        class="content-editor__offcanvas__iframe"
        name="editor"
        :src="url"></iframe>
    </div>
    <div
      v-show="url"
      @click="closeOffCanvas"
      class="offcanvas-backdrop fade show"></div>
  </section>
</template>
