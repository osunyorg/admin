<script>
import Picker from './Picker.vue'
export default {
  components: {
    Picker,
  },
  data () {
    return {
      endpoint: '',
      data: {},
    }
  },
  mounted() {
    this.endpoint = document.getElementById('picker-test-app').dataset.endpoint;
  }
};
</script>

<template>
  <Picker
    v-model="data"
    :endpoint="endpoint" />
  <div class="bg-light p-3 rounded mt-4">
    <pre><code>{{ data }}</code></pre>
  </div>
</template>
