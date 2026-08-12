<script>
import logicMixin from './_mixin.js';
import Placeholder from './Placeholder.vue';

export default {
  name: 'SelectedPaper',
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
      <span class="osuny__thumbnail__initials">
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
