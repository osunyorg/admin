<script>
import logicMixin from './_mixin.js';
import SelectedObject from '../selected-objects/SelectedObject.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'PageSelector',
  mixins: [logicMixin],
  components: { SelectedObject, Picker },
};
</script>

<template>
  <SelectedObject
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
