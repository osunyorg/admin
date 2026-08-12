<script>
import logicMixin from './_mixin.js';
import SelectedPage from '../selected-objects/SelectedPage.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'PageSelector',
  mixins: [logicMixin],
  components: { SelectedPage, Picker },
};
</script>

<template>
  <SelectedPage
    v-if="hasValue"
    :id="modelValue"
    :endpoint="objectEndpoint" />
  <Picker
    v-else
    :model-value="null"
    @update:model-value="select"
    kind="pages"
    :label="label"
    :title="title"
    :endpoint="pickerEndpoint" />
</template>
