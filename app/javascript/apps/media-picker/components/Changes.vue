<script>
export default {
    props: ['modelValue'],
    emits: ['update:modelValue'],
    computed: {
      value: {
        get() {
          return this.modelValue;
        },
        set(value) {
          this.$emit('update:modelValue', value);
        }
      },
      needsSaving: {
        get() {
          if (!this.mounted) {
            return false;
          }
          return JSON.stringify(this.modelValue) !== JSON.stringify(this.archive);
        }
      }
    },
    data () {
      return {
        mounted: false,
        savingInProgress: false,
        archive: {},
        i18n: {},
        csrfToken: "",
      }
    },
    methods: {
      save() {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', this.i18n.endpoint, true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
        xhr.onreadystatechange = function () {
          if (xhr.readyState != 4) return;
          if (xhr.status == 200) {
            this.archive = JSON.parse(xhr.responseText);
            this.value = JSON.parse(xhr.responseText);
            this.savingInProgress = false;
          }
        }.bind(this);
        xhr.send(JSON.stringify(this.modelValue));
        this.savingInProgress = true;
      },
      cancel() {
        this.value = JSON.parse(JSON.stringify(this.archive));
        this.needsSaving = false;
      },
    },
    beforeMount() {
      this.i18n = JSON.parse(document.getElementById('media-picker-app').dataset.i18n).changes;
      this.csrfToken = document.querySelector('[name="csrf-token"]').content;
    },
    mounted() {
      this.archive = JSON.parse(JSON.stringify(this.modelValue));
      this.mounted = true;
    },
};
</script>

<template>
  <div  class="media-picker__changes"
        :class="{'media-picker__changes--changed': needsSaving}">
    <button type="button"
            class="btn btn-light media-picker__changes__cancel"
            v-on:click="cancel()"
            :disabled="savingInProgress">
      {{ i18n.cancel }}
    </button>
    <button type="button"
            class="btn btn-success media-picker__changes__save"
            v-on:click="save()"
            :disabled="savingInProgress">
      {{ i18n.save }}
    </button>
  </div>
</template>
