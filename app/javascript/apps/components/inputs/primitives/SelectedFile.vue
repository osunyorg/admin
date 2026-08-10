<script>
export default {
  name: 'SelectedFile',
  props: {
    filename: { type: String, default: '' },
  },
  emits: ['remove'],
};
</script>

<template>
  <div class="mb-3">
    <p class="mb-0">
      {{ filename }}
      <a
        class="btn btn-sm text-danger small ps-0"
        @click="$emit('remove')">
        <i class="fas fa-times"></i>
        {{ $t('components.inputs.fileSelector.remove') }}
      </a>
    </p>
  </div>
</template>
