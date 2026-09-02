<script>
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';
import PublicationState from './PublicationState.vue';

export default {
  name: 'SelectedFile',
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
    <div 
      v-if="resource?.featured_media"
      class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped"
      >
      <img
        v-if="resource?.featured_media"
        :src="resource?.featured_media"
        loading="lazy"
        decoding="async"
        width="70"
        height="70" 
        />
    </div>
    <div
      v-else
      class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--uncropped"
      >
      <span class="osuny__thumbnail__icon">
        <i :class="resource?.icon"></i>
      </span>
    </div>
    <div class="card-body">
      <PublicationState :published="resource?.published" />
      {{ resource?.name }}
      <a
        :href="resource?.path"
        class="small float-end"
        target="_blank"
        >
        {{ $t('components.selectedObjects.open') }}
      </a>
    </div>
  </div>
</template>
