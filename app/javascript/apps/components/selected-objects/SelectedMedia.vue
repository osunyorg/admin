<script>
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';
export default {
  name: 'SelectedMedia',
  mixins: [logicMixin],
  components: {
    Placeholder
  },
};
</script>

<template>
  <img
    :src="resource?.thumb"
    loading="lazy"
    decoding="async"
    class="img-fluid" />
</template>
