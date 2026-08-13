<script>
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';

export default {
  name: 'SelectedFile',
  mixins: [logicMixin],
  components: { Placeholder },
};
</script>

<template>
  <Placeholder
    v-if="loading" />
  <div
    v-else
    class="card card--osuny card--horizontal">
    <div class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--uncropped">
      <img
        v-if="resource?.featured_image"
        :src="resource?.featured_image.thumb"
        loading="lazy"
        decoding="async"
        width="70"
        height="70" />
      <span
        v-else
        class="osuny__thumbnail__icon">
        <i :class="resource?.icon"></i>
      </span>
    </div>
    <div class="card-body">
      {{ resource?.name }}
    </div>
  </div>
</template>
