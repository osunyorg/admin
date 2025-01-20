<script>
import { CloudDownload } from 'lucide-vue-next';

export default {
    components: {
      CloudDownload
    },
    data () {
      return {
      }
    },
    methods: {
    },
    mounted() {
    }
};
</script>

<template>
  <button type="button"
        class="btn btn-sm ms-n2"
        v-on:click="cloudOpen()">
  <CloudDownload stroke-width="1.5" />
  Importer (Unsplash &amp; Pexels)
</button>

</template>
