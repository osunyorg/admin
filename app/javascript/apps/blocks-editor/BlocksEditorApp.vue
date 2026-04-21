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
      this.refresh();
    },
    async mounted() {
      window.osuny.blocks = {
        editor: {
          onSave: this.onSave.bind(this)
        }
      }
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
      refresh() {
        this.loadJson(this.url.blocks, "blocks");
      },
      onAdd() {
        this.url.current = this.url.new;
        this.openOffCanvas();
      },
      onEdit(block) {
        this.url.current = block.url.edit;
        this.openOffCanvas();
      },
      onSave() {
        this.closeOffCanvas();
        this.refresh();
      },
      onClose() {
        this.closeOffCanvas();
      },
      openOffCanvas() {
        document.body.classList.add("modal-open");
      },
      closeOffCanvas() {
        this.url.current = "";
        document.body.classList.remove("modal-open");
      }
    }
};
</script>

<template>
  <section class="vue__blocks-editor mb-5">
    <AddBlockButton
      :i18n="i18n"
      @add="onAdd" />
    <Blocks
      v-model="blocks"
      :i18n="i18n"
      @edit="onEdit" />
    <OffCanvas
      :i18n="i18n"
      :url="url.current"
      @close="onClose"
      />
  </section>
</template>