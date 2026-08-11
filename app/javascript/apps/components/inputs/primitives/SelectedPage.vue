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
      <span class="placeholder d-block" style="width: 120px; height: 1rem;"></span>
    </div>
    <template v-else>
      <p class="mb-0">
        {{ page?.title }}
        <a
          class="btn btn-sm text-danger p-0 small"
          @click="$emit('remove')">
          <i class="fas fa-times"></i>
          {{ $t('components.inputs.pageSelector.remove') }}
        </a>
      </p>
    </template>
  </div>
</template>
