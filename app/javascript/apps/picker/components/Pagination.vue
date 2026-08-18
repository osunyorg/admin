<script>
import { ArrowRight, ArrowLeft } from '@lucide/vue';

export default {
  components: {
    ArrowRight,
    ArrowLeft,
  },
  props: [
    'pagination'
  ],
  emits: [
    'change',
  ],
  methods: {
    update() {
      this.pagination.query_parameters = '&page=' + this.pagination.current_page;
      this.$emit('change')
    },
    previousPage() {
      this.pagination.current_page = Math.max(1, this.pagination.current_page - 1);
      this.update();
    },
    nextPage() {
      this.pagination.current_page = this.pagination.current_page + 1
      this.update();
    },
  }
};
</script>

<template>
  <div
    v-if="pagination?.total_pages > 1"
    class="d-flex justify-content-between mt-4">
    <div>
      <button
        class="btn btn-sm ps-0"
        v-if="pagination?.current_page > 1"
        @click.prevent="previousPage">
        <ArrowLeft stroke-width="1.5" />
        <span class="sr-only">
          {{ $t('picker.pagination.previous') }}
        </span>
      </button>
    </div>
    <p class="m-0">
      {{ pagination?.current_page }} / {{ pagination?.total_pages }}
    </p>
    <div>
      <button
        class="text-end btn btn-sm pe-0"
        v-if="pagination?.current_page < pagination?.total_pages"
        @click.prevent="nextPage">
        <span class="sr-only">
          {{ $t('picker.pagination.next') }}
        </span>
        <ArrowRight stroke-width="1.5" />
      </button>
    </div>
  </div>
</template>
