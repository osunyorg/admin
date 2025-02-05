<script>
import Categories from './Categories.vue';

export default {
    components: { 
      Categories,
    },
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
  <div v-for="taxonomy in value" class="mb-4">
    <p class="small text-muted mb-1">{{ taxonomy.name }}</p>
    <Categories v-model="taxonomy.categories" @toggle="toggle" />
  </div>
</template>
