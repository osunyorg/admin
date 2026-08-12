<script>
import Picker from './Picker.vue'
export default {
  components: {
    Picker,
  },
  data () {
    return {
      dataset: {},
      data: {},
    }
  },
  mounted() {
    this.dataset = document.getElementById('picker-test-app').dataset
  }
};
</script>

<template>
  <Picker
    v-model="data"
    :kind="dataset.kind"
    :endpoint="dataset.endpoint"
    :label="dataset.label" 
    :title="dataset.title" />
  <div class="bg-light p-3 rounded mt-4">
    <pre><code>{{ data }}</code></pre>
  </div>
</template>
