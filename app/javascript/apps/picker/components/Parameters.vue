<script>
import ValuesInFilter from './parameters/ValuesInFilter.vue';

export default {
  components: {
    ValuesInFilter
  },
  props: [
    'parameters'
  ],
  emits: [
    'change',
  ],
  methods: {
    update() {
      this.buildQuery();
      this.$emit('change');
    },
    buildQuery() {
      this.parameters.query_parameters = "&filters[for_search_term]=" + this.parameters.search.term;
      this.parameters.filters.forEach(filter => {
        this.addSelectedValuesToQuery(filter.values);
      });
    },
    addSelectedValuesToQuery(values) {
      values.forEach(value => {
        if (value.selected) {
          this.parameters.query_parameters += value.query_parameters;
        }
        // Recursive children
        if (value.values) {
          this.addSelectedValuesToQuery(value.values);
        }
      });
    },
  },
};
</script>

<template>
  <div class="vue__picker__parameters">
    <div class="mb-3" v-if="parameters.search">
      <b>{{ $t('picker.parameters.search.title')}}</b>
      <input  type="text"
              name="search"
              class="form-control mb-2"
              :placeholder="$t('picker.parameters.search.placeholder')"
              v-model="parameters.search.term"
              @keyup="update">
    </div>
    <div  v-for="filter in parameters.filters"
          class="mb-3">
      <b>{{ filter.name }}</b>
      <ValuesInFilter :values="filter.values" @change="update" />
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
