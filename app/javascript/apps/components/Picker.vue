<script>
import Pagination from './picker/Pagination.vue';
import Parameters from './picker/Parameters.vue';

export default {
  name: 'Picker',
  components: {
    Pagination,
    Parameters,
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
      url: '',
      parameters: {},
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
          data;
      this.buildUrl();
      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
          data = JSON.parse(xhr.responseText);
          this.parameters = data.parameters;
          this.results = data.results;
        }
      }.bind(this);
      xhr.open("GET", this.url, false);
      xhr.send();
    },
    buildUrl() {
      this.url = this.endpoint + '?';
      if (this.parameters.pagination) {
        this.url += '&page=' + this.parameters.pagination.current_page;
      }
    },
    select(event, object) {
      event.preventDefault();
      this.value = object.data;
      this.close();
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
                <Parameters
                  :parameters="parameters"
                  @change="search" />
              </div>
              <div class="col-md-10">
                <Pagination 
                  :pagination="parameters.pagination"
                  @change="search" />
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
