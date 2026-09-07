<script>
export default {
  name: 'Warning',
  props: {
    active: { type: Boolean, required: true },
    title: { type: String, required: true },
    text: { type: String, required: true },
    close: { type: String, required: true },
  },
  data() {
    return {
      stateActive: false,
    }
  },
  watch: {
    active(value) {
      this.stateActive = value;
    },
  },
  methods: {
    closeModal() {
      this.stateActive = false;
    },
  },
}
</script>

<template>
  <div
    class="modal"
    tabindex="-1"
    role="dialog"
    :class="{'d-block': stateActive}">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ title }}</h5>
          <button
            type="button"
            class="btn-close"
            @click="closeModal">
          </button>
        </div>
        <div
          class="modal-body"
          v-html="text">
        </div>
        <div class="modal-footer">
          <button
            type="button"
            class="btn btn-sm btn-secondary ms-auto"
            @click="closeModal">
            {{ close }}
          </button>
        </div>
      </div>
    </div>
  </div>
  <div
    class="modal-backdrop"
    :class="{'show': active, 'd-none': !stateActive}">
  </div>
</template>