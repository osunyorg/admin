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
        new: '',
        reorder: '',
        data: '',
      },
      data: {},
      planMode: false,
      offcanvasState: 'closed', // closed, picking, editing
      editorUrl: '',
    };
  },
  beforeMount() {
    this.csrfToken = document.querySelector('[name="csrf-token"]').content;
    const dataset = document.getElementById('blocks-editor-app').dataset;
    this.url.data = dataset.dataUrl;
    this.url.new = dataset.newUrl;
    this.url.reorder = dataset.reorderUrl;
    this.refresh();
  },
  methods: {
    async loadJson(url, target) {
      const res = await fetch(url, { headers: { Accept: 'application/json' } });
      if (!res.ok) return;
      this[target] = await res.json();
      if (this.data.blocks) {
        this.loading = false;
      }
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
    onPickerCreated(editUrl) {
      // A template was picked and the block was created — swap the picker
      // for the editor on the new block, keeping the offcanvas open.
      this.editorUrl = editUrl;
      this.offcanvasState = 'editing';
      this.refresh();
    },
    onDuplicate(block) {
      this.loadAndRefresh(block.url.duplicate, 'POST');
    },
    async onCopy(block) {
      const res = await fetch(block.url.copy, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
        },
      });
      if (res.ok) this.onCopyDone();
    },
    onCopyDone() {
      const notyf = new Notyf();
      notyf.open({
        type: 'success',
        position: { x: 'left', y: 'bottom' },
        message: this.$t('blocksEditor.confirm.copy'),
        duration: 9000,
        ripple: true,
        dismissible: true,
      });
    },
    onDelete(block) {
      this.loadAndRefresh(block.url.delete, 'DELETE');
    },
    closeOffcanvas() {
      // Single handler for the editor's save+close events and the shell's
      // backdrop click — all three converge on the same outcome: tear down
      // the offcanvas and resync the block list from the server.
      this.offcanvasState = 'closed';
      this.editorUrl = '';
      this.refresh();
    },
    async onReorder() {
      const ids = this.data.blocks.map((b) => b.id);
      const res = await fetch(this.url.reorder, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
        },
        body: JSON.stringify({ ids }),
      });
      if (res.ok) this.refresh();
    },
    async loadAndRefresh(url, method) {
      const res = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
        },
      });
      if (res.ok) this.refresh();
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
            {{ $t('blocksEditor.actions.addBlock') }}</a>
          <a
            class="btn btn-sm float-md-end"
            :class="{'btn-success': planMode, 'btn-light': !planMode}"
            @click="planMode = !planMode"
            v-show="data.blocks.length > 2">
            <i class="fas fa-list"></i>
            {{ $t('blocksEditor.planMode.button') }}</a>
        </div>
      </div>
      <Blocks
        v-model="data.blocks"
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
            {{ $t('blocksEditor.actions.addBlock') }}</a>
        </div>
      </div>
      <OffcanvasShell
        :open="offcanvasState !== 'closed'"
        :title="$t('blocksEditor.offcanvas.title')"
        :close-label="$t('blocksEditor.offcanvas.close')"
        @close="closeOffcanvas">
        <TemplatePicker
          v-if="offcanvasState === 'picking'"
          :url="url.new"
          :csrf-token="csrfToken"
          @created="onPickerCreated" />
        <Editor
          v-else-if="offcanvasState === 'editing'"
          :url="editorUrl"
          @save="closeOffcanvas"
          @close="closeOffcanvas" />
      </OffcanvasShell>
    </div>
  </section>
</template>
