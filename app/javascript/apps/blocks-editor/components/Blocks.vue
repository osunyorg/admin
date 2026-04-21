<script>
import { VueDraggableNext } from "vue-draggable-next";

export default {
    components: {
      draggable: VueDraggableNext,
    },
    props: [
      'modelValue',
      'i18n',
    ],
    emits: [
      'update:modelValue',
      'edit',
      'delete',
      'copy',
      'duplicate',
      'reorder'
    ],
    computed: {
      value: {
        get() {
          return this.modelValue;
        },
        set(value) {
          this.$emit('update:modelValue', value);
        }
      },
    },
    methods: {
      onEdit(event, block) {
        event.preventDefault();
        this.$emit('edit', block);
      },
      onReorder() {
        this.$emit('reorder');
      },
      onDelete(event, block) {
        event.preventDefault();
        if (!confirm(this.i18n.blocksEditor.confirm.deletion)) return;
        this.$emit('delete', block);
      },
      onCopy(event, block) {
        event.preventDefault();
        this.$emit('copy', block);
      },
      onDuplicate(event, block) {
        event.preventDefault();
        if (!confirm(this.i18n.blocksEditor.confirm.duplication)) return;
        this.$emit('duplicate', block);
      },
    }
};
</script>

<template>
  <section>
    <draggable
      :list="value.blocks"
      @change="onReorder"
      handle=".handle">
      <div
        v-for="block in value.blocks"
        class="content-editor__elements__element">
        <div class="row">
          <div class="col-lg-4 text-lg-end pt-2">
            <label class="form-label">{{ block.template.name }}</label>
          </div>
          <div class="col-lg-8 col-xxl-6">
            <article class="card card-body px-3 px-sm-5 border-bottom border-light">
              <div class="text-end mb-2">
                <span class="content-editor__elements__element--hover">
                  <span class="content-editor__elements__handle">
                    <span class="handle">
                      <i class="fas fa-sort"></i>
                      <span class="small"> Déplacer</span>
                    </span>
                  </span>
                  <a
                    href="#"
                    class="action text-danger ms-2"
                    @click="onDelete($event, block)">
                    {{ i18n.blocksEditor.actions.delete }}</a>
                  <a
                    href="#"
                    class="action ms-2"
                    @click="onCopy($event, block)">
                    {{ i18n.blocksEditor.actions.copy }}</a>
                  <a
                    href="#"
                    class="action ms-2"
                    @click="onDuplicate($event, block)">
                    {{ i18n.blocksEditor.actions.duplicate }}</a>
                </span>
                <a 
                  href="#"
                  class="action ms-2"
                  @click="onEdit($event, block)">
                  {{ i18n.blocksEditor.actions.edit }}</a>
              </div>
              <div
                class="content-editor__elements__preview"
                :class="`content-editor__elements__preview--${block.template.kind}`">
                <div v-html="block.snippet"></div>
              </div>
              <span v-html="block.a11y.status"></span>
            </article>
          </div>
        </div>
      </div>
    </draggable>
  </section>
</template>