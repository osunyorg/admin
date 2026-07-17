<script>
export default {
  props: [
    'parameters'
  ],
  emits: [
    'change',
  ],
  methods: {
    update() {
      this.parameters.query_parameters = "&filters[for_search_term]=" + this.parameters.search.term;
      this.$emit('change');
    },
  }
};
</script>

<template>
  <div class="vue__picker__parameters">
    <div class="mb-3" v-if="parameters.search">
      <b>{{ $t('picker.parameters.search')}}</b>
      <input  type="text"
              name="search"
              class="form-control mb-2"
              placeholder="Tapez le texte"
              v-model="parameters.search.term"
              @keyup="update">
    </div>
    <div class="mb-3">
      <b>{{ $t('picker.parameters.filters')}}</b>
      <div v-for="filter in parameters.filters">
        {{ filter.name }}
        <div v-for="value in filter.values">
          {{ value.name }}
        </div>
      </div>
    </div>
    <div class="mb-3">
      <b>{{ $t('picker.parameters.sorts')}}</b>
      <div v-for="sort in parameters.sorts">
        {{ sort.name }}
        {{ sort.selected }}
      </div>
    </div>
  </div>
</template>
