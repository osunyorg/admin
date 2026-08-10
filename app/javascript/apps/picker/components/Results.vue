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
  <div :class="results.classes">
    <div
      v-for="object in results.list"
      class="col"
      v-html="object.snippet"
      @click.prevent="$emit('select', object)">
    </div>
  </div>
</template>
