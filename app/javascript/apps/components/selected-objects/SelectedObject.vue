<script>
// Objet standard, à utiliser s'il n'y a rien de spécial
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';
import PublicationState from './PublicationState.vue';

export default {
  name: 'SelectedObject',
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
        v-if="resource?.featured_image"
        :src="resource?.featured_image.thumb"
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
      {{ resource?.title }}
    </div>
  </div>
</template>
