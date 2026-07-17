<script>
export default {
  props: [
    'results'
  ],
};
</script>

<template>
  <div class="row g-2">
    <div v-for="object in results">
      <div v-html="object.snippet" @click="select($event, object)"></div>
    </div>
  </div>
</template>
