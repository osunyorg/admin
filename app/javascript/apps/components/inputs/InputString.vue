<script>
import { Pencil } from 'lucide-vue-next';

export default {
    props: [
      'modelValue',
      'i18n',
      'id'
    ],
    emits: [
      'update:modelValue'
    ],
    components: {
      Pencil
    },
    computed: {
      value: {
        get() {
          return this.modelValue;
        },
        set(value) {
          this.$emit('update:modelValue', value);
        }
      }
    },
    data () {
      return {
        editing: false
      }
    },
    methods: {
      toggleEdition() {
        this.editing = !this.editing;
        if (this.editing) {
          this.$nextTick(() => {
            this.$refs.input.focus();
          });
        }
      }
    },
};
</script>

<template>
  <div class="mb-3">
    <label class="form-label" aria-label="{{ i18n.label }}" :for="id">
      {{ i18n.label }}
    </label>
    <div v-show="!editing" v-on:click="toggleEdition()">
      <p class="d-inline-block">{{ value }}</p>
      <a class="btn btn-xs"> 
        <Pencil stroke-width="2.5" 
                width="18"
                class="text-muted" />
      </a>
    </div>
    <div v-show="editing">
      <input  :id="id"
              class="form-control"
              data-translatable="true" 
              v-model="value"
              ref="input"
              type="text">
      <div class="form-text">{{ i18n.hint }}</div>
    </div>
  </div>
</template>
