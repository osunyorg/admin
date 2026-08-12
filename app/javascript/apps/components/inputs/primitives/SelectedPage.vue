<script>
import loadedObjectMixin from './loadedObjectMixin';
import Placeholder from './Placeholder.vue';

export default {
  name: 'SelectedPage',
  mixins: [loadedObjectMixin],
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
      <picture v-if="resource?.featured_image">
        <img  :src="resource?.featured_image.thumb"
              loading="lazy"
              decoding="async"
              width="140"
              height="140"
              class="img-fluid">
      </picture>
      <span v-else class="osuny__thumbnail__initials">
        {{ resource?.initials }}
      </span>
    </div>
    <div class="card-body">
      <span
        class="osuny__published"
        :class="{
          'osuny__published--true': resource?.published,
          'osuny__published--false': !resource?.published
        }"></span>
      {{ resource?.title }}
    </div>
  </div>
</template>
