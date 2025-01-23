<script>
export default {
    props: [
      'modelValue',
      'endpoint',
    ],
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
          if (this.mounted) {
            return JSON.stringify(this.modelValue) !== JSON.stringify(this.archive);
          } else {
            return false;
          }
        }
      }
    },
    data () {
      return {
        mounted: false,
        savingInProgress: false,
        archive: {},
        csrfToken: "",
        i18n: {},
      }
    },
    methods: {
      save() {
        let xhr = new XMLHttpRequest();
        xhr.open('POST', this.endpoint, true);
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
    mounted() {
      this.archive = JSON.parse(JSON.stringify(this.modelValue));
      this.csrfToken = document.querySelector('[name="csrf-token"]').content;
      this.mounted = true;
    },
};
</script>

<template>
  <div class="vue__changes" :class="{'vue__changes--changed': needsSaving}">
    <button type="button"
            class="btn btn-light vue__changes__cancel"
            v-on:click="cancel()"
            :disabled="savingInProgress">
      {{ i18n.cancel }}
    </button>
    <button type="button"
            class="btn btn-success vue__changes__save"
            v-on:click="save()"
            :disabled="savingInProgress">
      {{ i18n.save }}
    </button>
  </div>
</template>
