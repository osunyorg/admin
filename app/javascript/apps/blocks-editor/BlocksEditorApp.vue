<script>
import AddBlockButton from './components/AddBlockButton.vue';
import OffCanvas from './components/OffCanvas.vue';

export default {
    components: {
      AddBlockButton,
      OffCanvas
    },
    data () {
      return {
        i18n: {},
        newUrl: "",
        sortUrl: "",
        sourceUrl: "",
        currentUrl: ""
      }
    },
    beforeMount() {
      const dataset = document.getElementById('blocks-editor-app').dataset;
      this.loadJson(dataset.i18nUrl, "i18n");
      this.newUrl = dataset.newUrl;
      this.sortUrl = dataset.sortUrl;
      this.sourceUrl = dataset.sourceUrl;
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
      selectBlock(event) {
        event.preventDefault();
        this.currentUrl = this.newUrl;
        document.body.classList.add("modal-open");
      },
      closeOffCanvas() {
        this.currentUrl = "";
        document.body.classList.remove("modal-open");
      }
    }
};
</script>

<template>
  <section class="vue__blocks-editor">
    <AddBlockButton
      :label="i18n.blocksEditor.actions.addBlock"
      @click="selectBlock"
      />
    <OffCanvas
      :title="i18n.blocksEditor.offcanvas.title"
      :close="i18n.blocksEditor.offcanvas.close"
      :url="currentUrl"
      @closeOffCanvas="closeOffCanvas"
      />
  </section>
</template>