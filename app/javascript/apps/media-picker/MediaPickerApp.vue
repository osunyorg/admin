<script>
import Changes from './components/Changes.vue';
import Cloud from './components/Cloud.vue';
import Medias from './components/Medias.vue';
import ImageUploader from './components/ImageUploader.vue';

export default {
    components: {
      Changes,
      Cloud,
      Medias,
      ImageUploader,
    },
    data () {
      return {
        current: {},
        previous: {},
        i18n: {},
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
    beforeMount() {
      this.i18n = JSON.parse(document.getElementById('media-picker-app').dataset.i18n);
      this.current = JSON.parse(document.getElementById('media-picker-app').dataset.current);
    },
    mounted() {
      this.previous = JSON.parse(JSON.stringify(this.current));
    },
};
</script>

<template>
  <section class="pure__section flex-fill position-relative">
    <div class="d-lg-flex me-4 mb-0">
      <label class="form-label">{{i18n.image.title}}</label>
    </div>
    <div class="app-content">
      <div v-if="!current.image.url" class="media-picker__selector">
        <ImageUploader
          @done="uploaded"
          :i18n="i18n.upload"
          />
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
            {{ i18n.image.remove }}
          </a>
        </div>
        <div class="mb-3">
          <label class="form-label" aria-label="{{ i18n.image.alt.label }}" for="alt">
            {{ i18n.image.alt.label }}
          </label>
          <input  id="alt"
                  class="form-control"
                  data-translatable="true" 
                  v-model="current.image.alt"
                  type="text">
          <div class="form-text">{{ i18n.image.alt.hint }}</div>
        </div>
        <div class="mb-3 summernote">
          <label class="form-label" aria-label="<%= t('featured_image.credit.label') %>" for="credit">
            {{ i18n.image.credit.label }}
          </label>
          <textarea id="credit" 
                    class="form-control summernote-vue"
                    data-translatable="true"
                    v-model="current.image.credit"></textarea>
          <div class="form-text">{{ i18n.image.credit.hint }}</div>
        </div>
      </div>
    </div>
  </section>
  <Changes></Changes>
</template>
