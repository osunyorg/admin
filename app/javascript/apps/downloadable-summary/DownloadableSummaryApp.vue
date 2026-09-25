<script>
import { X } from '@lucide/vue';
import Changes from '../components/Changes.vue';
import FileInput from '../components/inputs/FileInput.vue';

export default {
  components: {
    Changes,
    FileInput,
    X,
  },
  data () {
    return {
      current: {},
    }
  },
  computed: {
    hasValue() {
      return this.current.downloadable_summary_id != '';
    },
  },
  methods: {
    remove() {
      this.current.downloadable_summary_id = '';
    },
  },
  beforeMount() {
    this.dataset = document.getElementById('downloadable-summary-app').dataset
    this.current = JSON.parse(this.dataset.current);
  },
};
</script>

<template>
  <FileInput
    accept="*"
    :object-endpoint="dataset.objectEndpoint"
    :picker-endpoint="dataset.pickerEndpoint"
    :picker-label="dataset.pickerLabel"
    :picker-title="dataset.pickerTitle"
    :uploader-endpoint="dataset.uploaderEndpoint"
    :uploader-size-limit="Number(dataset.uploaderSizeLimit)"
    v-model="current.downloadable_summary_id"
    />
  <div
    v-if="hasValue"
    class="text-end">
    <a
      class="btn btn-sm text-danger pe-0"
      @click="remove">
      <X stroke-width="1.5" />
      {{ $t('downloadableSummary.remove') }}
    </a>
  </div>
  <Changes
    v-model="current"
    :endpoint="dataset.changesEndpoint" />
</template>
