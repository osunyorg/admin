<script>
import logicMixin from './_mixin.js';
import SelectedProgram from '../selected-objects/SelectedProgram.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'ProgramSelector',
  mixins: [logicMixin],
  components: { SelectedProgram, Picker },
};
</script>

<template>
  <SelectedProgram
    v-if="hasValue"
    :id="modelValue"
    :endpoint="objectEndpoint" />
  <Picker
    v-else
    :model-value="null"
    @update:model-value="select"
    kind="programs"
    :label="label"
    :title="title"
    :endpoint="pickerEndpoint" />
</template>
