<script>
import SelectedPerson from '../selected-objects/SelectedPerson.vue';
import Picker from '../../picker/Picker.vue';

export default {
  name: 'PersonSelector',
  components: { SelectedPerson, Picker },
  props: {
    // Le modèle est l'identifiant de la personne
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
    clear() {
      this.$emit('update:modelValue', '');
    },
  },
};
</script>

<template>
  <SelectedPerson
    v-if="hasValue"
    :id="modelValue"
    :endpoint="objectEndpoint"
    @remove="clear" />
  <Picker
    v-else
    :model-value="null"
    @update:model-value="select"
    kind="people"
    :label="label"
    :title="title"
    :endpoint="pickerEndpoint" />
</template>
