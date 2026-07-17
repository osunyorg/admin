<script>
import { File } from '@lucide/vue';
import Pagination from './components/Pagination.vue';
import Parameters from './components/Parameters.vue';
import Results from './components/Results.vue';

export default {
  name: 'Picker',
  components: {
    File,
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
      modal: false,
      url: '',
      data: {},
      parameters: {},
      pagination: {},
      results: {},
    }
  },
  methods: {
    open() {
      if (this.modal) {
        return;
      }
      this.modal = true;
      document.body.classList.add("modal-open");
      this.search();
    },
    close() {
      if (!this.modal) {
        return;
      }
      this.modal = false;
      document.body.classList.remove("modal-open");
    },
    search() {
      var xhr = new XMLHttpRequest(),
          data;
      this.buildUrl();
      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
          this.data = JSON.parse(xhr.responseText);
          this.parameters = this.data.parameters;
          this.pagination = this.data.pagination;
          this.results = this.data.results;
        }
      }.bind(this);
      xhr.open("GET", this.url, false);
      xhr.send();
    },
    buildUrl() {
      this.url = this.endpoint + '?';
      if (this.parameters) {
        this.url += this.parameters.query_parameters;
      }
      if (this.pagination) {
        this.url += this.pagination.query_parameters;
      }
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
    @keydown.esc="close">
    <button class="btn btn-sm mx-n2 d-flex align-items-center"
      @click.prevent="open">
      <File stroke-width="1.5" class="me-1" />
      {{ $t(`picker.kind.${kind}.button`) }}
    </button>
    <div  class="modal"
          tabindex="-1"
          role="dialog"
          :class="{'d-block': modal}">
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
          <div class="modal-body overflow-x-hidden">
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
