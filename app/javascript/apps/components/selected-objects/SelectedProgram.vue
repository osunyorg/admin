<script>
// Le programme a un nom
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';
import PublicationState from './PublicationState.vue';

export default {
  name: 'SelectedProgram',
  mixins: [logicMixin],
  components: {
    Placeholder,
    PublicationState
  },
};
</script>

<template>
  <Placeholder
    v-if="loading" />
  <div
    v-else
    class="card card--osuny card--horizontal">
    <div class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped">
      <img
        v-if="resource?.featured_media"
        :src="resource?.featured_media"
        loading="lazy"
        decoding="async"
        width="70"
        height="70" />
      <span
        v-else
        class="osuny__thumbnail__initials">
        {{ resource?.initials }}
      </span>
    </div>
    <div class="card-body">
      <PublicationState :published="resource?.published" />
      {{ resource?.name }}
    </div>
  </div>
</template>
