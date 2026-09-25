<script>
// La personne a un nom (et un prénom), et son image est une photo
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';

export default {
  name: 'SelectedPerson',
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
    <div class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped">
      <img
        v-if="resource?.photo"
        :src="resource.photo.thumb"
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
      {{ resource?.name }}
    </div>
  </div>
</template>
