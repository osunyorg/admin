<script>
export default {
  props: [
    'modelValue',
    'i18n'
  ],
  emits: ['update:modelValue'],
  data() {
    return {
      preset: '0', // sélection par défaut
      custom: 42,
      presetValues: [
        ['1800', '30mn'],
        ['3600', '1h'],
        ['5400', '1h30'],
        ['7200', '2h'],
        ['9000', '2h30'],
        ['10800', '3h'],
        ['12600', '3h30'],
        ['14400', '4h'],
        ['18000', '5h'],
        ['21600', '6h'],
        ['25200', '7h'],
        ['28800', '8h'],
      ],
    };
  },
  created() {
    if (this.isInPresetValues(this.modelValue)) {
      this.preset = this.modelValue;
    } else {
      this.preset = 'custom';
      this.custom = this.modelValue;
    }
  },
  watch: {
    preset(newVal) {
      if (newVal === 'custom') {
        this.$emit('update:modelValue', this.custom);
      } else {
        this.$emit('update:modelValue', newVal);
      }
    },
    custom(newVal) {
      if (this.preset === 'custom') {
        this.$emit('update:modelValue', newVal);
      }
    },
    modelValue(newVal) {
      if (this.isInPresetValues(newVal)) {
        this.preset = String(newVal);
      } else {
        this.preset = 'custom';
        this.custom = newVal;
      }
    }
  },
  methods: {
    isInPresetValues(value) {
      value = String(value);
      if (value === '0') {
        return true;
      }
      return this.presetValues.some(p => p[0] === value);
    },
  },
};
</script>

<template>
  <div>
    <select class="form-select" v-model="preset">
      <option value="0">{{ i18n.label }}</option>
      <option v-for="value in presetValues" :key="value[0]" :value="value[0]">
        {{ value[1] }}
      </option>
      <option value="custom">{{ i18n.custom }}</option>
    </select>
    <div>
      <input type="number" class="form-control" v-model.number="custom" v-if="preset === 'custom'">
    </div>
  </div>
</template>
