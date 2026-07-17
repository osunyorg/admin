<script>
export default {
  props: [
    'results'
  ],
  emits: [
    'select',
  ],
};
</script>

<template>
  <div class="row g-2">
    <div v-for="object in results.list">
      <div v-html="object.snippet" @click.prevent="$emit('select', object)"></div>
    </div>
  </div>
</template>
