<script>

export default {
    props: [
      'modelValue',
      'i18n'
    ],
    emits: ['update:modelValue'],
    data () {
        return {
            custom: 42,
            presetValue: '0',
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
            ]
        }
    },
    computed: {
      value: {
        get() {
          if (this.preset === 'custom') {
            return this.custom;
          } else {
            return this.modelValue;
          }
        },
        set(value) {
          if (this.isInPresetValues(value)) {
            this.preset = value;
          } else {
            this.preset = 'custom'; 
          }
          this.$emit('update:modelValue', value);
        }
      },
      preset: {
        get() {
          return this.presetValue;
        },
        set(value) {
          this.presetValue = value;
          this.$emit('update:modelValue', value);
        }
      }
    },
    methods: {
      isInPresetValues(value) {
        for (var i = 0; i < this.presetValues.length; i++) {
          var preset = this.presetValues[i];
          if (preset[0] == value) {
            return true;
          }
        }
        return false;
      }
    },
};
</script>

<template>
  <div>
    <select class="form-select" v-model="preset">
      <option value="0">{{ i18n.label }}</option>
      <option v-for="value in presetValues" :value="value[0]">{{ value[1] }}</option>
      <option value="custom">{{ i18n.custom }}</option>
    </select>
    <div>
      <input  type="number"
              class="form-control"
              v-model="custom"
              v-if="preset === 'custom'"> 
      {{ value }} •
      {{ preset }} •
      {{ custom }}
    </div>
  </div>
</template>
