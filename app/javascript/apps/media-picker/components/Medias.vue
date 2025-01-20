<script>
import { Image } from 'lucide-vue-next';

export default {
    components: {
      Image
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
          class="btn btn-sm mx-n2"
          v-on:click="mediasOpen()">
    <Image stroke-width="1.5" />
    Choisir dans la médiathèque
  </button>
</template>
