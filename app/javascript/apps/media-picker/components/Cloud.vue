<script>
import { CloudDownload } from 'lucide-vue-next';

export default {
    components: {
      CloudDownload
    },
    data () {
      return {
        modal: false,
        query: "",
        unsplash: {
          page: 1,
          data: {
            results: [],
            total: 0,
            total_pages: 0,
          }
        },
        pexels: {
          page: 1,
          data: {
            results: [],
            total: 0,
            total_pages: 0,
          }
        },
        i18n: {},
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
        this.searchUnsplash();
        this.searchPexels();
      },
      searchUnsplash() {
        var url = this.i18n.unsplash.endpoint
                      + '?query=' + encodeURIComponent(this.query)
                      + '&page=' + this.unsplash.page
                      + '&per_page=12&lang=' + this.lang;
        this.loadSearchResults(url, this.unsplash);
      },
      searchPexels() {
        var url = this.i18n.pexels.endpoint
                    + '?query=' + encodeURIComponent(this.query)
                    + '&page=' + this.pexels.page
                    + '&per_page=12&lang=' + this.lang;
        this.loadSearchResults(url, this.pexels);
      },
      loadSearchResults(url, source) {
        if (!this.query) {
          return null;
        }
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            source.data.results = [];
            source.data = JSON.parse(xhr.responseText);
          }
        }.bind(this);
        xhr.open("GET", url, false);
        xhr.send();
      },
      selectUnsplash(image) {
        this.$emit('unsplashSelected', image);
        this.close();
      },
      selectPexels(image) {
        this.$emit('pexelsSelected', image);
        this.close();
      },
    },
    watch: {
      'unsplash.page': function() {
        this.searchUnsplash();
      },
      'pexels.page': function() {
        this.searchPexels();
      },
    },
    beforeMount() {
      const dataset = document.getElementById('media-picker-app').dataset;
      this.lang = dataset.lang;
      this.query = JSON.parse(dataset.current).about.name;
      this.i18n = JSON.parse(dataset.i18n).cloud;
    },
};
</script>

<template>
  <div>
    <button type="button"
          class="btn btn-sm ms-n2"
          @click="open()">
      <CloudDownload stroke-width="1.5" />
      {{ i18n.button }}
    </button>
    <div class="modal show" tabindex="-1" role="dialog" :class="{'d-block': modal}">
      <div class="modal-dialog modal-fullscreen modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <div class="col-auto d-none d-lg-block">
              <h5 class="modal-title">{{ i18n.title }}</h5>
            </div>
            <div class="col-auto d-flex flex-fill mx-lg-5">
              <div class="input-group">
                <input  type="text"
                        name="search"
                        class="form-control ms-auto"
                        :placeholder="i18n.placeholder"
                        v-model="query"
                        v-on:keyup.enter="search">
                <button type="button"
                        class="btn btn-primary me-auto"
                        @click="search"
                        aria-label="<%= t 'photo_import.search' %>">
                  {{ i18n.search }}
                </button>
              </div>
            </div>
            <div class="col-auto">
              <button type="button" 
                      class="btn-close"
                      @click="close()">
              </button>
            </div>
          </div>
          <div class="modal-body overflow-x-hidden">
            <div class="row">
              <div class="col-lg-6">
                <p v-if="unsplash.data.results.length === 0" >
                  {{ i18n.nothing }}
                </p>
                <div class="vue__media-picker__results">
                  <img  :src="image.thumb"
                        :alt="image.alt"
                        class="vue__media-picker__results__result"
                        v-for="image in unsplash.data.results"
                        @click="selectUnsplash(image)">
                </div>
                <p v-if="unsplash.data.total_pages" class="small text-muted mt-5">
                  {{ unsplash.page }} / {{ unsplash.data.total_pages }}
                </p>
              </div>
              <div class="col-lg-6">
                <p v-if="pexels.data.results.length === 0" >
                  {{ i18n.nothing }}
                </p>
                <div class="vue__media-picker__results">
                  <img  :src="image.thumb"
                        :alt="image.alt"
                        class="vue__media-picker__results__result"
                        v-for="image in pexels.data.results"
                        @click="selectPexels(image)">
                </div>
                <p v-if="pexels.data.total_pages" class="small text-muted mt-5">
                  {{pexels.page}} / {{pexels.data.total_pages }}
                </p>
              </div>
            </div>
          </div>
          <div class="modal-footer d-block">
            <div class="row">
              <div class="col-lg-6">
                <div class="row vue__media-picker__unsplash vue__media-picker__unsplash__nav">
                  <div class="col-lg-5">
                    <button
                        class="btn btn-light btn-sm"
                        v-if="unsplash.page > 1"
                        @click="unsplash.page = unsplash.page - 1">
                      {{ i18n.previous }}
                    </button>
                  </div>
                  <div class="col-lg-2 text-center">
                    <img :src="i18n.unsplash.logo" width="100" alt="Unsplash" />
                  </div>
                  <div class="col-lg-5 text-end">
                    <button
                        class="btn btn-light btn-sm"
                        v-if="unsplash.page < unsplash.data.total_pages"
                        @click="unsplash.page = unsplash.page + 1">
                      {{ i18n.next }}
                    </button>
                  </div>
                </div>
              </div>
              <div class="col-lg-6">
                <div class="row vue__media-picker__pexels vue__media-picker__pexels__nav">
                  <div class="col-lg-5">
                    <button
                        class="btn btn-light btn-sm"
                        v-if="pexels.page > 1"
                        @click="pexels.page = pexels.page - 1">
                      {{ i18n.previous }}
                    </button>
                  </div>
                  <div class="col-lg-2 text-center">
                    <img :src="i18n.pexels.logo" width="100" alt="Pexels" />
                  </div>
                  <div class="col-lg-5 text-end">
                    <button
                        class="btn btn-light btn-sm"
                        v-if="pexels.page < pexels.data.total_pages"
                        @click="pexels.page = pexels.page + 1">
                      {{ i18n.next }}
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
