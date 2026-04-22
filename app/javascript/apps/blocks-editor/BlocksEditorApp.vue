<script>
import Blocks from './components/Blocks.vue';
import OffCanvas from './components/OffCanvas.vue';

export default {
    components: {
      Blocks,
      OffCanvas
    },
    data () {
      return {
        loading: true,
        csrfToken: "",
        url: {
          i18n: "",
          new: "",
          reorder: "",
          data: "",
          current: ""
        },
        i18n: {},
        data: {},
        currentUrl: "",
        planMode: false
      }
    },
    beforeMount() {
      // CSRF
      this.csrfToken = document.querySelector('[name="csrf-token"]').content;
      // Récupération des paramètres de l'application
      const dataset = document.getElementById('blocks-editor-app').dataset;
      this.url.i18n = dataset.i18nUrl;
      this.url.data = dataset.dataUrl;
      this.url.new = dataset.newUrl;
      this.url.reorder = dataset.reorderUrl;
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
        xhr.open("GET", url, false);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this[target] = JSON.parse(xhr.responseText);
          }
        }.bind(this);
        xhr.send();
      },
      refresh() {
        this.loadJson(this.url.data, "data");
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
        let xhr = new XMLHttpRequest();
        xhr.open("POST", block.url.copy, false);
        xhr.onreadystatechange = function() {
          if (xhr.readyState == 4 && xhr.status == 200) {
            this.onCopyDone();
          }
        }.bind(this);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("X-CSRF-Token", this.csrfToken);
        xhr.send();
      },
      onCopyDone() {
        let notyf = new Notyf();
        notyf.open({
            type: 'success',
            position: {
                x: 'center',
                y: 'bottom'
            },
            message: this.i18n.blocksEditor.confirm.copy,
            duration: 9000,
            ripple: true,
            dismissible: true
        });
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
      openOffCanvas() {
        document.body.classList.add("modal-open");
      },
      closeOffCanvas() {
        this.url.current = "";
        this.refresh();
        document.body.classList.remove("modal-open");
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
  <section
    class="vue__blocks-editor mb-5"
    :class="{'vue__blocks-editor--plan-mode': planMode }">
    <div class="row my-4">
      <div class="offset-lg-4 col-lg-8 col-xxl-6">
        <a
          class="btn btn-lg btn-dark me-2 mb-2"
          @click="onAdd">
          {{ i18n.blocksEditor.actions.addBlock }}</a>
        <a
          class="btn btn-sm float-md-end"
          :class="{'btn-success': planMode, 'btn-light': !planMode}"
          @click="planMode = !planMode"
          v-show="data.blocks.length > 2">
          <i class="fas fa-list"></i>
          {{ i18n.blocksEditor.planMode.button }}</a>
      </div>
    </div>
    <Blocks
      v-model="data.blocks"
      :i18n="i18n"
      @edit="onEdit"
      @delete="onDelete"
      @copy="onCopy"
      @duplicate="onDuplicate"
      @reorder="onReorder" />
    <div
      class="row my-4"
      v-show="data.blocks.length > 4">
      <div class="offset-lg-4 col-lg-8 col-xxl-6">
        <a
          class="btn btn-lg btn-dark"
          @click="onClick">
          {{ i18n.blocksEditor.actions.addBlock }}</a>
      </div>
    </div>
    <OffCanvas
      :i18n="i18n"
      :url="url.current"
      @close="onClose"
      />
  </section>
</template>