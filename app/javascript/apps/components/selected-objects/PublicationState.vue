<script>
export default {
  name: 'PublicationState',
  props: [
    'published'
  ],
};
</script>
<template>
  <span
    class="osuny__published"
    :class="{
      'osuny__published--true': published,
      'osuny__published--false': !published
    }"></span>
</template>
