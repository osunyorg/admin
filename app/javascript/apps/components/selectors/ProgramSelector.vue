<script>
import SelectedProgram from '../selected-objects/SelectedProgram.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'ProgramSelector',
  components: { SelectedProgram, Picker },
  props: {
    // Le modèle est l'identifiant
    // Ex: 7da86f39-08cc-490c-bef2-79323b397cf1
    modelValue: { type: String, default: '' },
    pickerEndpoint: { type: String, required: true },
    objectEndpoint: { type: String, required: true },
    label: { type: String, required: true },
    title: { type: String, required: true },
  },
  emits: ['update:modelValue'],
  computed: {
    hasValue() {
      return this.modelValue !== '';
    },
  },
  methods: {
    select(person) {
      this.$emit('update:modelValue', person.id);
    },
  },
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
