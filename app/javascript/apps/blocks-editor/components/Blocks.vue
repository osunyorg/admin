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
      :list="value"
      @change="onReorder"
      handle=".handle">
      <div
        v-for="block in value"
        class="content-editor__elements__element">
        <div
          class="row"
          :class="{'draft': !block.published}">
          <div class="col-lg-4 text-lg-end pt-2">
            <label class="form-label">{{ block.template.name }}</label>
          </div>
          <div class="col-lg-8 col-xxl-6">
            <div class="card card-body border-bottom py-1 border-light plan-mode--true">
              <p class="handle small mb-0 text-truncate">
                <i class="fas fa-sort me-2"></i>
                {{ block.text }}
              </p>
            </div>
            <div class="card card-body border-bottom border-light px-3 px-sm-5 plan-mode--false">
              <div class="text-end mb-2">
                <span class="content-editor__elements__element--hover">
                  <span class="content-editor__elements__handle">
                    <span class="handle">
                      <i class="fas fa-sort"></i>
                      <span class="small">
                         {{ i18n.blocksEditor.actions.move }}
                      </span>
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
            </div>
          </div>
        </div>
      </div>
    </draggable>
  </section>
</template>