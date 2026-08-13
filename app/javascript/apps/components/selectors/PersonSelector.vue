<script>
import logicMixin from './_mixin.js';
import SelectedPerson from '../selected-objects/SelectedPerson.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'PersonSelector',
  mixins: [logicMixin],
  components: { SelectedPerson, Picker },
};
</script>

<template>
  <SelectedPerson
    v-if="hasValue"
    :id="modelValue"
    :endpoint="objectEndpoint" />
  <Picker
    v-else
    @update:model-value="select"
    :label="label"
    :title="title"
    :endpoint="pickerEndpoint" />
</template>
