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
  <div class="mt-4">
    <div v-if="pagination?.total_count === 0" >
      <div class="row align-items-center">
        <div class="col-lg-4">
          <img
            src="/vue/nothing.jpg"
            alt=""
            class="img-fluid mb-4"
            loading="lazy" />
        </div>
        <div class="offset-lg-1 col-lg-4">
          <p class="lead mb-3">{{ $t('picker.pagination.nothing.title') }}</p>
          <p class="text-muted small" v-html="$t('picker.pagination.nothing.text')"></p>
        </div>
      </div>
    </div>
    <div v-if="pagination?.total_pages > 1" class="d-flex justify-content-between mb-2">
      <div class="vue__picker__button_container">
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
      <div class="vue__media-picker__button_container text-end">
        <button
          class="btn btn-sm pe-0"
          v-if="pagination?.current_page < pagination?.total_pages"
          @click.prevent="nextPage">
          <span class="sr-only">
            {{ $t('picker.pagination.next') }}
          </span>
          <ArrowRight stroke-width="1.5" />
        </button>
      </div>
    </div>
  </div>
</template>
