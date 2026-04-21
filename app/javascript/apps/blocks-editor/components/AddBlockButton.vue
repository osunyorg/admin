<script>
export default {
    props: [
      'i18n'
    ],
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
        {{ i18n.blocksEditor.actions.addBlock }}</a>
    </div>
  </div>
</template>
