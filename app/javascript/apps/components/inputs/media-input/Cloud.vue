<script>
import { CloudDownload, ArrowRight, ArrowLeft } from '@lucide/vue';

export default {
    components: {
      CloudDownload,
      ArrowRight,
      ArrowLeft
    },
    emits: [
      'selected'
    ],
    props: {
      endpoint: { type: String, required: true },
    },
    data () {
      return {
        modal: false,
        query: '',
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
        let url = this.settings.unsplash.endpoint
                    + '?query=' + encodeURIComponent(this.query)
                    + '&page=' + this.unsplash.page
                    + '&per_page=12&lang=' + this.lang;
        this.loadSearchResults(url, this.unsplash);
      },
      searchPexels() {
        let url = this.settings.pexels.endpoint
                    + '?query=' + encodeURIComponent(this.query)
                    + '&page=' + this.pexels.page
                    + '&per_page=12&lang=' + this.lang;
        this.loadSearchResults(url, this.pexels);
      },
      loadSearchResults(url, source) {
        if (!this.query) {
          return null;
        }
        let xhr = new XMLHttpRequest();
        xhr.open("GET", url, false);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            source.data.results = [];
            source.data = JSON.parse(xhr.responseText);
          }
        }.bind(this);
        xhr.send();
      },
      selectUnsplash(data) {
        this.close();
        this.upload('unsplash', data)
      },
      selectPexels(data) {
        this.close();
        this.upload('pexels', data)
      },
      upload(origin, data) {
        let xhr = new XMLHttpRequest();
        xhr.open("POST", this.endpoint, false);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('X-CSRF-Token', document.querySelector('[name="csrf-token"]').content);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this.$emit('selected', xhr.responseText);
          }
        }.bind(this);
        data.origin = origin;
        xhr.send(JSON.stringify(data));
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
      const dataset = document.getElementById('featured-media-app').dataset;
      this.lang = document.documentElement.lang;
      this.query = dataset.searchTerm;
      this.settings = JSON.parse(dataset.cloud);
    },
};
</script>

<template>
  <div>
    <button type="button"
          class="btn btn-sm ms-n2"
          @click="open()">
      <CloudDownload stroke-width="1.5" />
      {{ $t('components.inputs.mediaInput.cloud.button') }}
    </button>
    <div class="modal" tabindex="-1" role="dialog" :class="{'d-block': modal}">
      <div class="modal-dialog modal-fullscreen modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <div class="col-auto d-none d-lg-block">
              <h5 class="modal-title">
                {{ $t('components.inputs.mediaInput.cloud.title') }}
              </h5>
            </div>
            <div class="col-auto d-flex flex-fill mx-lg-5">
              <div class="input-group">
                <input
                  type="text"
                  name="search"
                  class="form-control ms-auto"
                  :placeholder="$t('components.inputs.mediaInput.cloud.placeholder')"
                  v-model="query"
                  @keyup.enter="search">
                <button
                  type="button"
                  class="btn btn-primary me-auto"
                  @click="search"
                  :aria-label="$t('components.inputs.mediaInput.cloud.search')">
                  {{ $t('components.inputs.mediaInput.cloud.search') }}
                </button>
              </div>
            </div>
            <div class="col-auto">
              <button
                type="button"
                class="btn-close"
                @click="close()">
              </button>
            </div>
          </div>
          <div class="modal-body overflow-x-hidden">
            <div class="row">
              <div class="col-lg-6">
                <p v-if="unsplash.data.results.length === 0" >
                  {{ $t('components.inputs.mediaInput.cloud.nothing') }}
                </p>
                <div
                  v-if="unsplash.data.total_pages"
                  class="d-flex justify-content-between mb-2">
                  <div class="vue__media-picker__button_container">
                    <button
                      class="btn btn-sm ps-0"
                      v-if="unsplash.page > 1"
                      @click="unsplash.page = unsplash.page - 1"
                      :title="$t('components.inputs.mediaInput.cloud.previous')">
                      <ArrowLeft stroke-width="1.5" />
                    </button>
                  </div>
                  <p class="m-0">
                    {{ unsplash.page }} / {{ unsplash.data.total_pages }}
                  </p>
                  <div class="vue__media-picker__button_container text-end">
                    <button
                      class="btn btn-sm pe-0"
                      v-if="unsplash.page < unsplash.data.total_pages"
                      @click="unsplash.page = unsplash.page + 1"
                      :title="$t('components.inputs.mediaInput.cloud.next')">
                      <ArrowRight stroke-width="1.5" />
                    </button>
                  </div>
                </div>
                <div class="vue__media-picker__results">
                  <img  :src="image.thumb"
                        :alt="image.alt"
                        class="vue__media-picker__results__result"
                        v-for="image in unsplash.data.results"
                        @click="selectUnsplash(image)">
                </div>
              </div>
              <div class="col-lg-6">
                <p v-if="pexels.data.results.length === 0" >
                  {{ $t('components.inputs.mediaInput.cloud.nothing') }}
                </p>
                <div
                  v-if="pexels.data.total_pages"
                  class="d-flex justify-content-between mb-2">
                  <div class="vue__media-picker__button_container">
                    <button
                      class="btn btn-sm ps-0"
                      v-if="pexels.page > 1"
                      @click="pexels.page = pexels.page - 1"
                      :title="$t('components.inputs.mediaInput.cloud.previous')">
                      <ArrowLeft stroke-width="1.5" />
                    </button>
                  </div>
                  <p class="m-0">
                    {{ pexels.page }} / {{ pexels.data.total_pages }}
                  </p>
                  <div class="vue__media-picker__button_container text-end">
                    <button
                      class="btn btn-sm pe-0"
                      v-if="pexels.page < pexels.data.total_pages"
                      @click="pexels.page = pexels.page + 1"
                      :title="$t('components.inputs.mediaInput.cloud.next')">
                      <ArrowRight stroke-width="1.5" />
                    </button>
                  </div>
                </div>
                <div class="vue__media-picker__results">
                  <img  :src="image.thumb"
                        :alt="image.alt"
                        class="vue__media-picker__results__result"
                        v-for="image in pexels.data.results"
                        @click="selectPexels(image)">
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer d-block d-flex justify-content-between">
            <img :src="settings.unsplash.logo" width="100" alt="Unsplash" />
            <img :src="settings.pexels.logo" width="100" alt="Pexels" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
