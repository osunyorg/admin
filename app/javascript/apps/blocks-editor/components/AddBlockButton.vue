<script>
export default {
    props: {
      label: { type: String, required: true },
    },
    emits: ['add'],
    methods: {
      onClick(event) {
        event.preventDefault();
        this.$emit('add');
      },
    },
};
</script>

<template>
  <div class="row my-4">
    <div class="offset-lg-4 col-lg-8 col-xxl-6">
      <a
        class="btn btn-lg btn-dark"
        @click="onClick">
        {{ label }}</a>
    </div>
  </div>
</template>
