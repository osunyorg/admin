<script>
import AddBlockButton from './components/AddBlockButton.vue';

export default {
    components: {
      AddBlockButton
    },
    data () {
      return {
        i18n: {}
      }
    },
    beforeMount() {
      const dataset = document.getElementById('blocks-editor-app').dataset;
      this.loadJson(dataset.i18n, "i18n");
    },
    methods: {
      loadJson(url, target) {
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this[target] = JSON.parse(xhr.responseText);
          }
        }.bind(this);
        xhr.open("GET", url, false);
        xhr.send();
      },
    },
    mounted() {
    }
};
</script>

<template>
  <section class="vue__blocks-editor">
    Blocks editor
    {{ i18n }}
    <AddBlockButton />
  </section>
</template>