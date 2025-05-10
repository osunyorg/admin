<script>
import { Image } from 'lucide-vue-next';
import Taxonomies from './medias/Taxonomies.vue';

export default {
    components: {
      Image,
      Taxonomies
    },
    data () {
      return {
        modal: false,
        query: "",
        selected: {
          collections: [],
          categories: []
        },
        page: 1,
        data: {
          results: [],
          total: 0,
          collections: [],
          categories: [],
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
        var xhr = new XMLHttpRequest(),
            url = this.endpoint
                    + "?filters[for_search_term]=" + encodeURIComponent(this.query);
        for (var i = 0; i < this.selected.collections.length; i++) {
          url += "&filters[for_collection][]=" + this.selected.collections[i];
        };
        for (var i = 0; i < this.selected.categories.length; i++) {
          url += "&filters[for_category][]=" + this.selected.categories[i];
        };
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this.data = JSON.parse(xhr.responseText);
          }
        }.bind(this);
        xhr.open("GET", url, false);
        xhr.send();
      },
      toggleCollection(collection) {
        this.toggle(this.selected.collections, collection);
        this.search();
      },
      toggleCategory(category) {
        this.toggle(this.selected.categories, category);
        this.search();
      },
      toggle(array, value) {
        if (array.includes(value)) {
          array.splice(array.indexOf(value), 1);
        } else {
          array.push(value);
        }
      },
      select(image) {
        this.$emit('mediaSelected', image);
        this.close();
      },
    },
    beforeMount() {
      const dataset = document.getElementById('media-picker-app').dataset;
      this.i18n = JSON.parse(dataset.i18n).mediaPicker.medias;
      this.endpoint = dataset.mediaEndpoint;
    },
};
</script>

<template>
  <div>
    <button type="button"
            class="btn btn-sm mx-n2"
            @click="open()">
      <Image stroke-width="1.5" />
      {{ i18n.button }}
    </button>
    <div  class="modal"
          tabindex="-1"
          role="dialog"
          :class="{'d-block': modal}">
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
                        :aria-label="i18n.search"
                        @click="search">
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
              <div class="col-md-2">
                <div class="mb-4">
                  <p class="small text-muted mb-1">{{ i18n.collections }}</p>
                  <div v-for="collection in data.collections" class="form-check">
                    <input  class="form-check-input"
                            type="checkbox"
                            :id="'collection' + collection.id"
                            @change="toggleCollection(collection.id)"
                            />
                    <label  class="form-check-label"
                            :for="'collection' + collection.id">
                      {{collection.name}}
                    </label>
                  </div>
                </div>
                <Taxonomies v-model="data.taxonomies" @toggle="toggleCategory" />
              </div>
              <div class="col-md-10">
                <p v-if="data.results.length === 0" >{{ i18n.nothing }}</p>
                <div class="vue__media-picker__results--medias">
                  <img  :src="media.thumb"
                        :alt="media.alt"
                        class="vue__media-picker__results__result"
                        v-for="media in data.results"
                        @click="select(media)">
                </div>
                <p v-if="data.total_pages && data.results.length > 0" class="small text-muted mt-5">
                  {{page}} / {{data.total_pages }}
                </p>
              </div>
            </div>
          </div>
          <div class="modal-footer d-block" v-if="data.total_pages > 1">
            <div class="row">
              <div class="col-lg-6">
                <button
                    v-if="page > 1"
                    @click="page = page - 1"
                    class="btn btn-light btn-sm">
                  {{ i18n.previous }}
                </button>
              </div>
              <div class="col-lg-6 text-end">
                <button
                    v-if="page < data.total_pages"
                    @click="page = page + 1"
                    class="btn btn-light btn-sm">
                  {{ i18n.next }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
