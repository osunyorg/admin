<script>
import AddBlockButton from './components/AddBlockButton.vue';
import Blocks from './components/Blocks.vue';
import OffCanvas from './components/OffCanvas.vue';

export default {
    components: {
      AddBlockButton,
      Blocks,
      OffCanvas
    },
    data () {
      return {
        url: {
          i18n: "",
          new: "",
          sort: "",
          blocks: "",
          current: ""
        },
        i18n: {},
        blocks: {},
        currentUrl: ""
      }
    },
    beforeMount() {
      // Récupération des paramètres de l'application
      const dataset = document.getElementById('blocks-editor-app').dataset;
      this.url.i18n = dataset.i18nUrl;
      this.url.blocks = dataset.blocksUrl;
      this.url.new = dataset.newUrl;
      this.url.sort = dataset.sortUrl;
      // Chargement
      this.loadJson(this.url.i18n, "i18n");
      this.loadJson(this.url.blocks, "blocks");
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
        this.openOffCanvas();
      },
      editBlock(block) {
        this.currentUrl = block.url.edit;
        this.openOffCanvas();
      },
      openOffCanvas() {
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
  <section class="vue__blocks-editor mb-5">
    <AddBlockButton :i18n="i18n" @click="selectBlock" />
    <Blocks
      v-model="blocks"
      :i18n="i18n"
      @edit="editBlock" />
    <OffCanvas
      :title="i18n.blocksEditor.offcanvas.title"
      :close="i18n.blocksEditor.offcanvas.close"
      :url="currentUrl"
      @close="closeOffCanvas"
      />
  </section>
</template>