<script>
import { ArrowRight, ArrowLeft } from '@lucide/vue';

export default {
  name: 'Picker',
  components: {
    ArrowRight,
    ArrowLeft
  },
  props: [
    'modelValue',
    'endpoint',
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
      term: '',
      filters: {},
      sorts: {},
      pagination: {},
      results: {},
    }
  },
  methods: {
    open() {
      this.modal = true;
      document.body.classList.add("modal-open");
      this.search();
    },
    close() {
      this.modal = false;
      document.body.classList.remove("modal-open");
    },
    search() {
      var xhr = new XMLHttpRequest(),
          url = this.endpoint,
          data;
      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
          data = JSON.parse(xhr.responseText);
          this.search = data.parameters.search;
          this.filters = data.parameters.filters;
          this.sorts = data.parameters.sorts;
          this.pagination = data.parameters.pagination;
          this.results = data.results;
        }
      }.bind(this);
      xhr.open("GET", url, false);
      xhr.send();
    },
    select(event, object) {
      event.preventDefault();
      this.value = object.data;
      this.close();
    },
    previousPage() {
      this.pagination.current_page = this.pagination.current_page - 1;
      this.search();
    },
    nextPage() {
      this.pagination.current_page = this.pagination.current_page + 1
      this.search();
    },
  },
};
</script>

<template>
  <section class="vue__picker">
    <a  class="btn btn-sm"
        @click="open">
      Choisir un fichier dans la bibliothèque de fichiers
    </a>
    <div  class="modal"
          tabindex="-1"
          role="dialog"
          :class="{'d-block': modal}">
      <div class="modal-dialog modal-fullscreen modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <div class="col-auto d-none d-lg-block ">
              <h5 class="modal-title">Sélecteur de fichiers</h5>
            </div>
            <button type="button"
                    class="btn-close"
                    @click="close">
            </button>
          </div>
          <div class="modal-body overflow-x-hidden">
            <div class="row">
              <div class="col-md-2">
                <div class="mb-3">
                  <b>Recherche</b>
                  <input  type="text"
                          name="search"
                          class="form-control mb-2"
                          placeholder="Tapez le texte"
                          v-model="term"
                          @keyup.enter="search">
                  <button type="button"
                          class="btn btn-primary btn-sm mb-2"
                          aria-label="Chercher"
                          @click="search">
                    Chercher
                  </button>
                </div>
                <div class="mb-3">
                  <b>Filtrer</b>
                  <div v-for="filter in filters">
                    {{ filter.name }}
                    <div v-for="value in filter.values">
                      {{ value.name }}
                    </div>
                  </div>
                </div>
                <div class="mb-3">
                  <b>Trier</b>
                  <div v-for="sort in sorts">
                    {{ sort.name }}
                    {{ sort.selected }}
                  </div>
                </div>
              </div>
              <div class="col-md-10">
                <p v-if="results.length === 0" >Aucun fichier</p>
                <div v-if="pagination.total_pages > 1" class="d-flex justify-content-between mb-2">
                  <div class="vue__media-picker__button_container">
                    <button
                      class="btn btn-sm ps-0"
                      v-if="pagination.current_page > 1"
                      @click="previousPage"
                      title="Page précédente">
                      <ArrowLeft stroke-width="1.5" />
                    </button>
                  </div>
                  <p class="m-0">
                    {{ pagination.current_page }} / {{ pagination.total_pages }}
                  </p>
                  <div class="vue__media-picker__button_container text-end">
                    <button
                      class="btn btn-sm pe-0"
                      v-if="pagination.current_page < pagination.total_pages"
                      @click="nextPage"
                      title="Page suivante">
                      <ArrowRight stroke-width="1.5" />
                    </button>
                  </div>
                </div>
                <div class="row g-2">
                  <div v-for="object in results">
                    <div v-html="object.snippet" @click="select($event, object)"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
