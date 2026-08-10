<script>
export default {
  name: 'ValuesInFilter',
  props: [
    'values'
  ],
  emits: [
    'change',
  ],
  methods: {
    update() {
      this.$emit('change');
    },
  },
};
</script>

<template>
  <div  v-for="value in values"
        class="form-check">
    <input  type="checkbox"
            :id="value.id"
            v-model="value.selected"
            class="form-check-input" 
            @change="update"/>
    <label  :for="value.id"
            class="form-check-label">
      {{ value.name }}
    </label>
    <div v-if="value.values">
      <ValuesInFilter :values="value.values" @change="update" />
    </div>
  </div>
</template>