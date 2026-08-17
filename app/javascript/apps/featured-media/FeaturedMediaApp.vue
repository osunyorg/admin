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
    mediaLoaded(data) {
      this.current.featured_media_alt = data.alt;
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
  <section class="vue__media-picker">
    <div class="app-content">
      <div class="vue__media-picker__selector">
        <MediaInput
          v-model="current.featured_media_id"
          :upload-endpoint="dataset.uploadEndpoint"
          :upload-hint="dataset.uploadHint"
          :cloud-select-endpoint="dataset.cloudSelectEndpoint"
          :object-endpoint="dataset.objectEndpoint"
          :picker-endpoint="dataset.pickerEndpoint"
          :accept="dataset.formatsAccepted"
          :size-limit="dataset.sizeLimit"
          @mediaLoaded="mediaLoaded"
          />
      </div>
      <div v-if="hasValue">
        <div class="mb-3">
          <label
            class="form-label"
            :aria-label="$t('featuredMedia.alt.label')"
            for="alt">
            {{ $t('featuredMedia.alt.label') }}
          </label>
          <input  id="alt"
                  class="form-control"
                  data-translatable="true"
                  v-model="current.featured_media_alt"
                  type="text">
          <div class="form-text">
            {{ $t('featuredMedia.alt.hint') }}
          </div>
        </div>
      </div>
    </div>
  </section>
  <Changes  v-model="current"
            :endpoint="dataset.changesEndpoint" />
</template>
