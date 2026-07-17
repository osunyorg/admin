<script>
export default {
  props: [
    'parameters'
  ],
  emits: [
    'change',
  ],
};
</script>

<template>
  <div class="vue__picker__parameters">
    <div class="mb-3">
      <b>Recherche</b>
      <input  type="text"
              name="search"
              class="form-control mb-2"
              placeholder="Tapez le texte"
              v-model="parameters.term"
              @keydown.enter.prevent="$emit('change')">
      <button type="button"
              class="btn btn-primary btn-sm mb-2"
              aria-label="Chercher"
              @click.prevent="$emit('change')">
        Chercher
      </button>
    </div>
    <div class="mb-3">
      <b>Filtrer</b>
      <div v-for="filter in parameters.filters">
        {{ filter.name }}
        <div v-for="value in filter.values">
          {{ value.name }}
        </div>
      </div>
    </div>
    <div class="mb-3">
      <b>Trier</b>
      <div v-for="sort in parameters.sorts">
        {{ sort.name }}
        {{ sort.selected }}
      </div>
    </div>
  </div>
</template>
