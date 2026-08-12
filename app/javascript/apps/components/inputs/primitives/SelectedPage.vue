<script>
export default {
  name: 'SelectedPage',
  props: {
    id: { type: String, required: true },
    endpoint: { type: String, required: true },
  },
  emits: ['remove'],
  data() {
    return {
      page: null,
      loading: true,
    };
  },
  watch: {
    id: {
      handler() {
        this.load();
      },
      immediate: true,
    },
  },
  methods: {
    async load() {
      this.loading = true;
      this.page = null;
      try {
        const res = await fetch(`${this.endpoint}/${this.id}.json`);
        if (!res.ok) throw new Error(res.statusText);
        this.page = await res.json();
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<template>
  <div>
    <div v-if="loading" class="placeholder-glow">
      <div class="card card--osuny card--horizontal">
        <div class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped">
          <picture class="placeholder" style="width: 140px; height: 140px;"></picture>
        </div>
        <div class="card-body">
          <span class="osuny__published osuny__published--false"></span>
          <span class="placeholder" style="width: 120px; height: 1rem;"></span>
        </div>
      </div>
    </div>
    <template v-else>
      <div class="card card--osuny card--horizontal">
        <div class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped">
          <picture v-if="page?.featured_image">
            <img  :src="page?.featured_image.thumb"
                  loading="lazy"
                  decoding="async"
                  width="140"
                  height="140"
                  class="img-fluid">
          </picture>
          <span v-else class="osuny__thumbnail__initials">
            {{ page?.initials }}
          </span>
        </div>
        <div class="card-body">
          <span
            class="osuny__published"
            :class="{ 
              'osuny__published--true': page?.published, 
              'osuny__published--false': !page?.published
            }"></span>
          {{ page?.title }}
        </div>
        <div class="card-footer">
          <a
            class="btn btn-sm text-danger p-0 small"
            @click="$emit('remove')">
            <i class="fas fa-times"></i>
            {{ $t('components.inputs.pageSelector.remove') }}
          </a>
        </div>
      </div>
    </template>
  </div>
</template>
