<script>
import Changes from '../components/Changes.vue';
import MediaInput from '../components/inputs/MediaInput.vue';
import Picker from '../picker/Picker.vue';
import Summernote from '../components/Summernote.vue';

export default {
    components: {
      Changes,
      MediaInput,
      Picker,
      Summernote,
    },
    data () {
      return {
        current: {},
        previous: {},
      }
    },
    methods: {
      resetOrigin() {
        this.current.origin = JSON.parse(JSON.stringify(this.previous.origin));
      },
      remove() {
        this.resetOrigin();
        this.current.media = '';
        this.current.origin.blob.delete = true;
      },
    },
    beforeMount() {
      this.dataset = document.getElementById('featured-image-app').dataset
      this.summernoteLang = this.dataset.summernoteLang;
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
        {{ $t('featuredImage.title') }}
      </label>
    </div>
    <div class="app-content">
      <div class="vue__media-picker__selector">
        <MediaInput
          v-model="current.media"
          :objectEndpoint="dataset.objectEndpoint"
          :pickerEndpoint="dataset.pickerEndpoint"
          :pickerLabel="$t('featuredImage.medias.button')"
          :pickerTitle="$t('featuredImage.medias.title')" 
          :accept="dataset.formatsAccepted"
          :size-limit="dataset.sizeLimit" 
          />
      </div>
      <div v-if="current.media">
        <div class="text-end">
          <a  class="btn btn-sm text-danger pe-0"
              @click="remove">
            <i class="<%= Icon::DELETE %>"></i>
            {{ $t('featuredImage.remove') }}
          </a>
        </div>
        <div class="mb-3">
          <label
            class="form-label"
            :aria-label="$t('featuredImage.alt.label')"
            for="alt">
            {{ $t('featuredImage.alt.label') }}
          </label>
          <input  id="alt"
                  class="form-control"
                  data-translatable="true"
                  v-model="current.image.alt"
                  type="text">
          <div class="form-text">
            {{ $t('featuredImage.alt.hint') }}
          </div>
        </div>
        <div class="mb-3 summernote">
          <label
            class="form-label"
            :aria-label="$t('featuredImage.credit.label')"
            for="credit">
            {{ $t('featuredImage.credit.label') }}
          </label>
          <Summernote id="credit"
                      :lang="summernoteLang"
                      v-model="current.image.credit" />
          <div class="form-text">
            {{ $t('featuredImage.credit.hint') }}
          </div>
        </div>
      </div>
    </div>
  </section>
  <Changes  v-model="current"
            :endpoint="dataset.changesEndpoint" />
</template>
