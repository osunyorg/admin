<script>
import Changes from '../components/Changes.vue';
import MediaInput from '../components/inputs/MediaInput.vue';

export default {
  components: {
    Changes,
    MediaInput,
  },
  data () {
    return {
      current: {},
    }
  },
  computed: {
    hasValue() {
      return this.current.featured_media_id != '';
    },
  },
  methods: {
    mediaSelected(data) {
      // on pré-remplit l'alt seulement s'il est vide, pour ne pas
      // reproposer un alt que l'utilisateur avait volontairement vidé
      if (this.current.featured_media_alt == '') {
        this.current.featured_media_alt = data.alt;
      }
    },
    cropped(data) {
      this.current.crop_settings = data;
    },
    unselected() {
      this.current.featured_media_alt = '';
    },
  },
  beforeMount() {
    this.dataset = document.getElementById('featured-media-app').dataset
    this.current = JSON.parse(this.dataset.current);
  },
  mounted() {
    this.previous = JSON.parse(JSON.stringify(this.current));
  },
};
</script>

<template>
  <MediaInput
    :accept="dataset.formatsAccepted"
    :cloud-default-query="dataset.cloudDefaultQuery"
    :cloud-unsplash-endpoint="dataset.cloudUnsplashEndpoint"
    :cloud-pexels-endpoint="dataset.cloudPexelsEndpoint"
    :cloud-select-endpoint="dataset.cloudSelectEndpoint"
    :context-about-gid="dataset.contextAboutGid"
    :crop-settings="current.crop_settings"
    :object-endpoint="dataset.objectEndpoint"
    :picker-endpoint="dataset.pickerEndpoint"
    :uploader-endpoint="dataset.uploadEndpoint"
    :uploader-hint="dataset.uploadHint"
    :uploader-size-limit="Number(dataset.sizeLimit)"
    v-model="current.featured_media_id"
    @media-selected="mediaSelected"
    @cropped="cropped"
    @unselected="unselected"
    />
  <div
    v-if="hasValue"
    class="mb-3">
      <label
        class="form-label"
        :aria-label="$t('featuredMedia.alt.label')"
        for="alt">
        {{ $t('featuredMedia.alt.label') }}
      </label>
      <input  id="alt"
              class="form-control"
              data-translatable="true"
              type="text"
              v-model="current.featured_media_alt"
              >
      <div class="form-text">
        {{ $t('featuredMedia.alt.hint') }}
      </div>
  </div>
  <Changes
    v-model="current"
    :endpoint="dataset.changesEndpoint" />
</template>
