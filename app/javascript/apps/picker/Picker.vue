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
  props: {
    modelValue: { default: null },
    // Chemin des données JSON
    // /admin/fr/communication/medias/picker.json
    endpoint: { type: String, required: true },
    // Texte du bouton, si vide, pas de bouton
    label: { type: String, default: '' },
    // Texte de la fenêtre
    title: { type: String, default: '' },
    // Concerne les fichiers et photos, 
    // permet de bloquer le choix sur un groupe d'extensions
    // en partant du paramètre accept de l'input file
    accept: { type: String, default: '*' },
  },
  emits: [
    'picked',
    'update:modelValue'
  ],
  computed: {
    value: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('picked', value);
        this.$emit('update:modelValue', value);
      }
    }
  },
  data () {
    return {
      loading: true,
      searching: false,
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
      document.body.classList.add('modal-open');
      this.search();
    },
    close() {
      if (!this.modalOpened) {
        return;
      }
      this.modalOpened = false;
      // Si l'offcanvas est ouvert, ou laisse tel quel
      if (!document.body.classList.contains('offcanvas-shell-open')) {
        document.body.classList.remove('modal-open');
      }
    },
    async search() {
      // Pour le feedback visuel immédiat
      this.searching = true;
      this.buildUrl();
      try {
        const res = await fetch(this.url);
        if (!res.ok) throw new Error(res.statusText);
        const data = await res.json();
        this.data = data;
        this.parameters = data.parameters;
        this.pagination = data.pagination;
        this.results = data.results;
        this.loading = false;
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
      } finally {
        this.searching = false;
      }
    },
    buildUrl() {
      this.url = this.endpoint + '?accept=' + this.accept;
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
    @keydown.esc="close">
    <button
      v-if="label"
      type="button"
      class="btn btn-sm mx-n2 d-flex align-items-center"
      @click.prevent="open">
      <CircleDot stroke-width="1.5" class="me-1" />
      {{ label }}
    </button>
    <div  class="modal"
          tabindex="-1"
          role="dialog"
          :class="{'d-block': modalOpened}">
      <div class="modal-dialog modal-fullscreen modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <div class="col-auto d-none d-lg-block ">
              <h1 class="h4 modal-title">{{ title }}</h1>
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
                <div :class="{'opacity-25': searching}">
                  <Results
                    :results="results"
                    @select="select" />
                  <Pagination
                    :pagination="pagination"
                    @change="search" />
                </div>
                <div v-if="searching" class="position-absolute top-0 end-0 me-4 mt-4">
                  <span class="spinner-border text-primary" role="status"></span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
