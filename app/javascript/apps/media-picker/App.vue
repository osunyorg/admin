<script>
import Changes from './components/Changes.vue';
import Cloud from './components/Cloud.vue';
import Medias from './components/Medias.vue';
import Upload from './components/Upload.vue';

export default {
    components: {
      Changes,
      Cloud,
      Medias,
      Upload
    },
    data () {
      return {
        current: {
          about: {
            type: null,
            id: null,
          },
          image: {
            alt: "",
            credit: "",
            url: ""
          },
          origin: {
            blob: {
              id: "",
              signed_id: "",
              delete: false,
            },
            cloud: {
              "pexels":{
                id: "",
                url: "",
              },
              "unsplash":{
                id: "",
                url: "",
              }
            },
            medias: {
              id: "",
            }
          }
        },
        previous: {},
      }
    },
    methods: {
      resetOrigin() {
        this.current.origin = JSON.parse(JSON.stringify(this.previous.origin));
      },
      removeImage() {
        this.resetOrigin();
        this.current.image.url = "";
        this.current.origin.blob.delete = true;
      },
      uploaded (blob) {
        this.resetOrigin();
        this.current.origin.blob = blob;
        this.current.image.url = this.current.origin.blob.url;
      },
    },
    mounted() {
      this.previous.origin = JSON.parse(JSON.stringify(this.current.origin));
    }
};
</script>

<template>
  <section class="pure__section flex-fill position-relative">
    <div class="d-lg-flex me-4 mb-0">
      <label class="form-label">Image</label>
    </div>
    <div class="app-content">
      <div v-if="!current.image.url" class="image-picker__selector">
        <Upload @uploaded="uploaded"></Upload>
        <div class="d-flex flex-wrap justify-content-between">
          <Cloud></Cloud>
          <Medias></Medias>
        </div>
      </div>
      <div v-if="current.image.url">
        <img :src="current.image.url" class="img-fluid" />
        <div class="text-end">
          <a  class="btn btn-sm text-danger pe-0"
              v-on:click="removeImage()">
            <i class="<%= Icon::DELETE %>"></i>
            <%= t('featured_image.remove') %>
          </a>
        </div>
        <div class="mb-3">
          <label class="form-label" aria-label="<%= t('featured_image.alt.label') %>" for="alt">
            <%= t('featured_image.alt.label') %>
          </label>
          <input  id="alt"
                  class="form-control"
                  data-translatable="true" 
                  v-model="current.image.alt"
                  placeholder="<%= t('featured_image.alt.label') %>"
                  type="text">
          <div class="form-text"><%= t('featured_image.alt.hint') %></div>
        </div>
        <div class="mb-3 summernote">
          <label class="form-label" aria-label="<%= t('featured_image.credit.label') %>" for="credit">
            <%= t('featured_image.credit.label') %>
          </label>
          <textarea id="credit" 
                    class="form-control summernote-vue"
                    data-translatable="true"
                    v-model="current.image.credit"
                    placeholder="<%= t('featured_image.credit.label') %>"></textarea>
          <div class="form-text"><%= t('featured_image.credit.hint') %></div>
        </div>
      </div>
    </div>
  </section>
  <Changes></Changes>
</template>
