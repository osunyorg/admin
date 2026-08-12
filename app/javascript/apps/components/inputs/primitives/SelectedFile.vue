<script>
import loadedObjectMixin from './loadedObjectMixin';
import Placeholder from './Placeholder.vue';

export default {
  name: 'SelectedFile',
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
      <span class="osuny__thumbnail__icon">
        <i :class="resource?.icon"></i>
      </span>
    </div>
    <div class="card-body">
      {{ resource?.name }}
    </div>
  </div>
</template>
