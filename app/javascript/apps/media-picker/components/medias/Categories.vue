<script>
export default {
    props: ['modelValue'],
    emits: [
      'update:modelValue',
      'toggle',
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
      toggle(category) {
        this.$emit('toggle', category);
      },
    },
};
</script>

<template>
  <div v-for="category in value" class="form-check">
    <input  class="form-check-input"
            type="checkbox"
            :id="'category' + category.id"
            @change="toggle(category.id)"
            />
    <label class="form-check-label" :for="'category' + category.id">
      {{ category.name }}
    </label>
    <Categories v-model="category.categories" @toggle="toggle" />
  </div>
</template>
