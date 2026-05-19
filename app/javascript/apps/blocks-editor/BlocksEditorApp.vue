<script>
import Blocks from './components/Blocks.vue';
import Editor from './components/Editor.vue';
import OffcanvasShell from './components/OffcanvasShell.vue';
import TemplatePicker from './components/TemplatePicker.vue';

export default {
  components: { Blocks, Editor, OffcanvasShell, TemplatePicker },
  data() {
    return {
      loading: true,
      csrfToken: '',
      url: {
        i18n: '',
        new: '',
        reorder: '',
        data: '',
      },
      i18n: {},
      data: {},
      planMode: false,
      offcanvasState: 'closed', // closed, picking, editing
      editorUrl: '',
    };
  },
  beforeMount() {
    this.csrfToken = document.querySelector('[name="csrf-token"]').content;
    const dataset = document.getElementById('blocks-editor-app').dataset;
    this.url.i18n = dataset.i18nUrl;
    this.url.data = dataset.dataUrl;
    this.url.new = dataset.newUrl;
    this.url.reorder = dataset.reorderUrl;
    this.loadJson(this.url.i18n, 'i18n');
    this.refresh();
  },
  methods: {
    loadJson(url, target) {
      const xhr = new XMLHttpRequest();
      xhr.open('GET', url);
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && xhr.status === 200) {
          this[target] = JSON.parse(xhr.responseText);
          if (this.i18n.blocksEditor && this.data.blocks) {
            this.loading = false;
          }
        }
      };
      xhr.send();
    },
    refresh() {
      this.loadJson(this.url.data, 'data');
    },
    onAdd() {
      this.offcanvasState = 'picking';
    },
    onEdit(block) {
      this.editorUrl = block.url.edit;
      this.offcanvasState = 'editing';
    },
    onPick(editUrl) {
      this.editorUrl = editUrl;
      this.offcanvasState = 'editing';
      this.refresh();
    },
    onDuplicate(block) {
      this.loadAndRefresh(block.url.duplicate, 'POST');
    },
    onCopy(block) {
      const xhr = new XMLHttpRequest();
      xhr.open('POST', block.url.copy);
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && xhr.status === 200) this.onCopyDone();
      };
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
      xhr.send();
    },
    onCopyDone() {
      const notyf = new Notyf();
      notyf.open({
        type: 'success',
        position: { x: 'left', y: 'bottom' },
        message: this.i18n.blocksEditor.confirm.copy,
        duration: 9000,
        ripple: true,
        dismissible: true,
      });
    },
    onDelete(block) {
      this.loadAndRefresh(block.url.delete, 'DELETE');
    },
    onSave() {
      this.closeOffcanvas();
      this.refresh();
    },
    onClose() {
      this.closeOffcanvas();
      this.refresh();
    },
    closeOffcanvas() {
      this.offcanvasState = 'closed';
      this.editorUrl = '';
    },
    onReorder() {
      const ids = this.data.blocks.map((b) => b.id);
      const xhr = new XMLHttpRequest();
      xhr.open('POST', this.url.reorder);
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && xhr.status === 200) this.refresh();
      };
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
      xhr.send(JSON.stringify({ ids }));
    },
    loadAndRefresh(url, method) {
      const xhr = new XMLHttpRequest();
      xhr.open(method, url);
      xhr.onreadystatechange = () => {
        if (xhr.readyState === 4 && xhr.status === 200) this.refresh();
      };
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
      xhr.send();
    },
  },
};
</script>

<template>
  <section class="vue__blocks-editor mb-5">
    <div v-if="loading">
      <div class="row my-4">
        <div class="offset-lg-4 col-lg-8 col-xxl-6">
          <span class="spinner-border spinner-border-sm" role="status"></span>
        </div>
      </div>
    </div>
    <div
      v-if="!loading"
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
            @click="onAdd">
            {{ i18n.blocksEditor.actions.addBlock }}</a>
        </div>
      </div>
      <OffcanvasShell
        :open="offcanvasState !== 'closed'"
        :title="i18n.blocksEditor.offcanvas.title"
        :close-label="i18n.blocksEditor.offcanvas.close"
        @close="onClose">
        <TemplatePicker
          v-if="offcanvasState === 'picking'"
          :url="url.new"
          :csrf-token="csrfToken"
          @created="onPick" />
        <Editor
          v-else-if="offcanvasState === 'editing'"
          :url="editorUrl"
          @save="onSave"
          @close="onClose" />
      </OffcanvasShell>
    </div>
  </section>
</template>
