<script>
export default {
    props: {
      label: { type: String, required: true },
    },
};
</script>

<template>
  <div class="row my-4">
    <div class="offset-lg-4 col-lg-8 col-xxl-6">
      <a class="btn btn-lg btn-dark">{{ label }}</a>
    </div>
  </div>
</template>
