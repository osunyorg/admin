<script>
export default {
    props: [
      'modelValue',
      'i18n',
    ],
    emits: [
      'update:modelValue',
      'edit'
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
      edit(event, block) {
        event.preventDefault();
        this.$emit('edit', block);
      }
    }
};
</script>

<template>
  <section>
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
                <a data-confirm="Est-ce que vous confirmez la suppression&nbsp;?" class="action text-danger ms-2" rel="nofollow" data-method="delete" href="/admin/fr/communication/blocks/a46eb74a-178f-40a4-b96e-e4b79766193c?website_id=27ccefe4-753c-49b3-ae4d-31675fc53ce5">Supprimer</a>
                <a class="action ms-2" data-remote="true" href="/admin/fr/communication/blocks/a46eb74a-178f-40a4-b96e-e4b79766193c/copy?website_id=27ccefe4-753c-49b3-ae4d-31675fc53ce5">Copier le bloc</a>
                <a data-confirm="Est-ce que vous confirmez la duplication&nbsp;?" class="action ms-2" rel="nofollow" data-method="post" href="/admin/fr/communication/blocks/a46eb74a-178f-40a4-b96e-e4b79766193c/duplicate?website_id=27ccefe4-753c-49b3-ae4d-31675fc53ce5">Dupliquer</a>
              </span>
              <a  href="#"
                  class="action ms-2"
                  @click="edit($event, block)">
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
  </section>
</template>