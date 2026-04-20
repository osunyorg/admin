<script>
export default {
    props: {
      url: { type: String, required: true },
      label: { type: String, required: true },
    },
    emits: ['open'],
    methods: {
      onClick(event) {
        event.preventDefault();
        this.$emit('open', this.url);
      },
    },
};
</script>

<template>
  <div class="content-editor__actions row my-4">
    <div class="offset-lg-4 col-lg-8 col-xxl-6">
      <a
        href="#"
        class="btn btn-lg btn-dark"
        @click="onClick">
        {{ label }}
      </a>
    </div>
  </div>
</template>
