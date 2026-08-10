<script>
export default {
  name: 'SelectedPerson',
  props: {
    id: { type: String, required: true },
    endpoint: { type: String, required: true },
  },
  emits: ['remove'],
  data() {
    return {
      person: null,
      loading: true,
    };
  },
  watch: {
    id: {
      handler() {
        this.loadPerson();
      },
      immediate: true,
    },
  },
  methods: {
    async loadPerson() {
      this.loading = true;
      this.person = null;
      try {
        const res = await fetch(`${this.endpoint}/${this.id}.json`);
        if (!res.ok) throw new Error(res.statusText);
        this.person = await res.json();
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
  <div class="mb-3 d-flex align-items-center">
    <div v-if="loading" class="d-flex align-items-center placeholder-glow">
      <span class="placeholder rounded-circle" style="width: 70px; height: 70px;"></span>
      <div class="ms-3">
        <span class="placeholder d-block mb-2" style="width: 120px; height: 1rem;"></span>
        <span class="placeholder rounded-pill d-block" style="width: 90px; height: 1.5rem;"></span>
      </div>
    </div>
    <template v-else>
      <div
        v-if="person?.photo"
        class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped rounded-circle">
        <img
          :src="person.photo.thumb"
          loading="lazy"
          decoding="async"
          width="70"
          height="70">
      </div>
      <div
        v-else
        class="osuny__thumbnail osuny__thumbnail--small osuny__thumbnail--cropped rounded-circle">
        <span class="osuny__thumbnail__initials">
          {{ person?.initials }}
        </span>
      </div>
      <div class="ms-3">
        <p class="mb-0">
          {{ person?.name }}
        </p>
        <a
          class="btn btn-sm text-danger mt-n2 p-0 small"
          @click="$emit('remove')">
          <i class="fas fa-times"></i>
          {{ $t('components.inputs.personSelector.remove') }}
        </a>
      </div>
    </template>
  </div>
</template>
