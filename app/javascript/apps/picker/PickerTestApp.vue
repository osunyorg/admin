<script>
import Picker from './Picker.vue'
export default {
  components: {
    Picker,
  },
  data () {
    return {
      endpoint: '',
      kind: '',
      data: {},
    }
  },
  mounted() {
    let dataset = document.getElementById('picker-test-app').dataset
    this.endpoint = dataset.endpoint;
    this.kind = dataset.kind;
  }
};
</script>

<template>
  <Picker
    v-model="data"
    :kind="kind"
    :endpoint="endpoint" />
  <div class="bg-light p-3 rounded mt-4">
    <pre><code>{{ data }}</code></pre>
  </div>
</template>
