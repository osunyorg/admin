<script>
import { CircleDot } from '@lucide/vue';
import Pagination from './components/Pagination.vue';
import Parameters from './components/Parameters.vue';
import Results from './components/Results.vue';

export default {
  name: 'Picker',
  components: {
    CircleDot,
    Pagination,
    Parameters,
    Results,
  },
  props: [
    'modelValue',
    'endpoint',
    'kind',
  ],
  emits: ['update:modelValue'],
  computed: {
    value: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      }
    }
  },
  data () {
    return {
      loading: true,
      modalOpened: false,
      url: '',
      data: {},
      parameters: {},
      pagination: {},
      results: {},
    }
  },
  methods: {
    open() {
      if (this.modalOpened) {
        return;
      }
      this.modalOpened = true;
      document.body.classList.add("modal-open");
      this.search();
    },
    close() {
      if (!this.modalOpened) {
        return;
      }
      this.modalOpened = false;
      document.body.classList.remove("modal-open");
    },
    async search() {
      this.buildUrl();
      try {
        const res = await fetch(this.url);
        if (!res.ok) throw new Error(res.statusText);
        this.data = await res.json();
        this.parameters = this.data.parameters;
        this.pagination = this.data.pagination;
        this.results = this.data.results;
        this.loading = false;
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
      }
    },
    buildUrl() {
      this.url = this.endpoint + '?';
      this.url += this.parameters?.query_parameters || '';
      this.url += this.pagination?.query_parameters || '';
    },
    select(object) {
      this.value = object.data;
      this.close();
    },
  },
};
</script>

<template>
  <section
    class="vue__picker"
    v-if="kind"
    @keydown.esc="close">
    <button
      class="btn btn-sm mx-n2 d-flex align-items-center"
      @click.prevent="open">
      <CircleDot stroke-width="1.5" class="me-1" />
      {{ $t(`picker.kind.${kind}.button`) }}
    </button>
    <div  class="modal"
          tabindex="-1"
          role="dialog"
          :class="{'d-block': modalOpened}">
      <div class="modal-dialog modal-fullscreen modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <div class="col-auto d-none d-lg-block ">
              <h1 class="h4 modal-title">{{ $t(`picker.kind.${kind}.modal.title`) }}</h1>
            </div>
            <button
              type="button"
              class="btn-close"      
              @click="close">
            </button>
          </div>
          <div class="modal-body overflow-x-hidden" v-if="!loading">
            <div class="row">
              <div class="col-md-2">
                <Parameters
                  :parameters="parameters"
                  @change="search" />
              </div>
              <div class="offset-md-1 col-md-9">
                <Results
                  :results="results"
                  @select="select" />
                <Pagination 
                  :pagination="pagination"
                  @change="search" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
