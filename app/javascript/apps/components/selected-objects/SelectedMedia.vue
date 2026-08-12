<script>
export default {
  name: 'SelectedMedia',
  props: {
    imageUrl: { type: String, default: '' },
  },
  emits: ['remove'],
};
</script>

<template>
  <div class="mb-3">
    <img :src="imageUrl" class="img-fluid mb-2" />
    <a class="btn btn-sm text-danger ps-0" @click="$emit('remove')">
      <i class="fas fa-times"></i>
      {{ $t('mediaPicker.remove') }}
    </a>
  </div>
</template>
