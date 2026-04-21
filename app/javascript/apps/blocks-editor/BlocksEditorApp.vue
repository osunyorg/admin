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
        csrfToken: "",
        url: {
          i18n: "",
          new: "",
          reorder: "",
          blocks: "",
          current: ""
        },
        i18n: {},
        blocks: {},
        loading: true,
        currentUrl: ""
      }
    },
    beforeMount() {
      // CSRF
      this.csrfToken = document.querySelector('[name="csrf-token"]').content;
      // Récupération des paramètres de l'application
      const dataset = document.getElementById('blocks-editor-app').dataset;
      this.url.i18n = dataset.i18nUrl;
      this.url.blocks = dataset.blocksUrl;
      this.url.new = dataset.newUrl;
      this.url.reorder = dataset.reorderUrl;
      // Chargement
      this.loadJson(this.url.i18n, "i18n");
      this.refresh();
    },
    async mounted() {
      this.loading = false;
      window.osuny.blocks = {
        editor: {
          onSave: this.onSave.bind(this)
        }
      }
    },
    methods: {
      loadJson(url, target) {
        let xhr = new XMLHttpRequest();
        xhr.open("GET", url, false);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this[target] = JSON.parse(xhr.responseText);
          }
        }.bind(this);
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
      onDuplicate(block) {
        this.loadAndRefresh(block.url.duplicate, "POST");
      },
      onCopy(block) {
        this.loadAndRefresh(block.url.copy, "POST");
      },
      onDelete(block) {
        this.loadAndRefresh(block.url.delete, "DELETE");
      },
      onSave() {
        this.closeOffCanvas();
        this.refresh();
      },
      onClose() {
        this.closeOffCanvas();
      },
      onReorder() {
        let ids = [];
        for (let index in this.blocks.blocks) {
          let block = this.blocks.blocks[index];
          ids.push(block.id);
        }
        let xhr = new XMLHttpRequest();
        xhr.open("POST", this.url.reorder, false);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this.refresh();
          }
        }.bind(this);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("X-CSRF-Token", this.csrfToken);
        xhr.send(JSON.stringify({ ids: ids }));
      },
      openOffCanvas() {
        document.body.classList.add("modal-open");
      },
      closeOffCanvas() {
        this.url.current = "";
        this.refresh();
        document.body.classList.remove("modal-open");
      },
      loadAndRefresh(url, method) {
        let xhr = new XMLHttpRequest();
        xhr.open(method, url, false);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this.refresh();
          }
        }.bind(this);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("X-CSRF-Token", this.csrfToken);
        xhr.send();
      }
    }
};
</script>

<template>
  <section class="vue__blocks-editor mb-5">
    <div v-if="loading" class="text-center text-muted py-5">
      <i class="lead fas fa-spinner fa-spin"></i>
    </div>

    <AddBlockButton
      :i18n="i18n"
      @add="onAdd" />
    <Blocks
      v-model="blocks"
      :i18n="i18n"
      @edit="onEdit"
      @delete="onDelete"
      @copy="onCopy"
      @duplicate="onDuplicate"
      @reorder="onReorder" />
    <AddBlockButton
      v-show="blocks.blocks.length > 5"
      :i18n="i18n"
      @add="onAdd" />
    <OffCanvas
      :i18n="i18n"
      :url="url.current"
      @close="onClose"
      />
  </section>
</template>