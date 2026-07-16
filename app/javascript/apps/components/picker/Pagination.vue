<script>
import { ArrowRight, ArrowLeft } from '@lucide/vue';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
  },
  props: [
    'data'
  ],
  emits: [
    'changePage',
  ],
  methods: {
    previousPage() {
      this.data.current_page = this.data.current_page - 1;
      this.$emit('changePage')
    },
    nextPage() {
      this.data.current_page = this.data.current_page + 1
      this.$emit('changePage')
    },
  }
};
</script>

<template>
  <div class="vue__picker__pagination">
    <p v-if="data?.total_count === 0" >Aucun fichier</p>
    <div v-if="data?.total_pages > 1" class="d-flex justify-content-between mb-2">
      <div class="vue__picker__button_container">
        <button
          class="btn btn-sm ps-0"
          v-if="data?.current_page > 1"
          @click.prevent="previousPage"
          title="Page précédente">
          <ArrowLeft stroke-width="1.5" />
        </button>
      </div>
      <p class="m-0">
        {{ data?.current_page }} / {{ data?.total_pages }}
      </p>
      <div class="vue__media-picker__button_container text-end">
        <button
          class="btn btn-sm pe-0"
          v-if="data?.current_page < data?.total_pages"
          @click.prevent="nextPage"
          title="Page suivante">
          <ArrowRight stroke-width="1.5" />
        </button>
      </div>
    </div>
  </div>
</template>
