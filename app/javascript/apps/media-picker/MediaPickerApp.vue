<script>
import Changes from '../components/Changes.vue';
import Cloud from './components/Cloud.vue';
import Medias from './components/Medias.vue';
import ImageUploader from './components/ImageUploader.vue';
import Summernote from '../components/Summernote.vue';

export default {
    components: {
      Changes,
      Cloud,
      Medias,
      ImageUploader,
      Summernote,
    },
    data () {
      return {
        current: {},
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
      uploaded(blob) {
        this.resetOrigin();
        this.current.origin.blob = blob;
        this.current.image.url = this.current.origin.blob.url;
      },
      unsplashSelected(image) {
        this.resetOrigin();
        this.current.origin.cloud.unsplash.id = image.id;
        this.current.origin.cloud.unsplash.url = image.preview;
        this.current.image.credit = image.credit;
        this.current.image.url = image.preview;
      },
      pexelsSelected(image) {
        this.resetOrigin();
        this.current.origin.cloud.pexels.id = image.id;
        this.current.origin.cloud.pexels.url = image.preview;
        this.current.image.credit = image.credit;
        this.current.image.url = image.preview;
      },
      mediaSelected(image) {
        this.resetOrigin();
        this.current.origin.medias.id = image.id;
        this.current.image.credit = image.credit;
        this.current.image.url = image.thumb;
      }
    },
    beforeMount() {
      const dataset = document.getElementById('media-picker-app').dataset
      this.i18n = JSON.parse(dataset.i18n);
      this.summernoteLang = dataset.summernoteLang;
      this.current = JSON.parse(dataset.current);
    },
    mounted() {
      this.previous = JSON.parse(JSON.stringify(this.current));
    },
};
</script>

<template>
  <section class="pure__section flex-fill position-relative">
    <div class="d-lg-flex me-4 mb-0">
      <label class="form-label">{{ i18n.image.title }}</label>
    </div>
    <div class="app-content">
      <div v-if="!current.image.url" class="media-picker__selector">
        <ImageUploader
          @uploaded="uploaded"
          :i18n="i18n.upload"
          />
        <div class="d-flex flex-wrap justify-content-between">
          <Cloud
            :i18n="i18n.cloud"
            @unsplashSelected="unsplashSelected"
            @pexelsSelected="pexelsSelected"
            />
          <Medias
            :i18n="i18n.medias"
            @mediaSelected="mediaSelected"
            />
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
          <label class="form-label" :aria-label="i18n.image.credit.label" for="credit">
            {{ i18n.image.credit.label }}
          </label>
          <Summernote
            id="credit"
            :lang="summernoteLang"
            v-model="current.image.credit"
            />
          <div class="form-text">{{ i18n.image.credit.hint }}</div>
        </div>
      </div>
    </div>
  </section>
  <Changes
    v-model="current"
    :button-save="i18n.changes.save"
    :button-cancel="i18n.changes.cancel"
    :endpoint="i18n.changes.endpoint"
    />
</template>
