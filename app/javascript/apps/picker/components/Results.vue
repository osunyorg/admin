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
      v-for="(object, index) in results.list"
      :key="index"
      class="col"
      v-html="object.snippet"
      @click.prevent="$emit('select', object)">
    </div>
  </div>
  <div v-if="results.list.length === 0" >
    <div class="row align-items-center">
      <div class="col-lg-4">
        <img
          src="/vue/nothing.jpg"
          alt=""
          class="img-fluid mb-4"
          loading="lazy" />
      </div>
      <div class="offset-lg-1 col-lg-4">
        <p class="lead mb-3">{{ $t('picker.results.nothing.title') }}</p>
        <p class="text-muted small" v-html="$t('picker.results.nothing.text')"></p>
      </div>
    </div>
  </div>
</template>
