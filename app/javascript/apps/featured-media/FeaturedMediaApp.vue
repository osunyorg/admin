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
    remove() {
      this.current.featured_media_id = '';
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
    <div class="d-lg-flex me-4 mb-0">
      <label class="form-label">
        {{ $t('featuredMedia.title') }}
      </label>
    </div>
    <div class="app-content">
      <div class="vue__media-picker__selector">
        <MediaInput
          v-model="current.featured_media_id"
          :uploadEndpoint="dataset.uploadEndpoint"
          :cloudSelectEndpoint="dataset.cloudSelectEndpoint"
          :objectEndpoint="dataset.objectEndpoint"
          :pickerEndpoint="dataset.pickerEndpoint"
          :pickerLabel="$t('featuredMedia.medias.button')"
          :pickerTitle="$t('featuredMedia.medias.title')" 
          :accept="dataset.formatsAccepted"
          :size-limit="dataset.sizeLimit"
          @mediaLoaded="mediaLoaded"
          />
      </div>
      <div v-if="hasValue">
        <div class="text-end">
          <a  class="btn btn-sm text-danger pe-0"
              @click="remove">
            <i class="<%= Icon::DELETE %>"></i>
            {{ $t('featuredMedia.remove') }}
          </a>
        </div>
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
