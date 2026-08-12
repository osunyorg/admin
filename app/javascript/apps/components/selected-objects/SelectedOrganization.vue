<script>
// L'organisation a un nom, pas un titre, et son image est un logo (pas de crop !)
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';

export default {
  name: 'SelectedOrganization',
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
        v-if="resource?.logo"
        :src="resource?.logo"
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
