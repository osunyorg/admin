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
      this.parameters.query_parameters = "&filters[for_search_term]=" + encodeURIComponent(this.parameters.search.term);
      this.parameters.filters.forEach(filter => {
        this.addSelectedValuesToQuery(filter.values);
      });
      this.parameters.sort.values.forEach(sort => {
        if (sort.id === this.parameters.sort.current) {
          this.parameters.query_parameters += sort.query_parameters;
        }
      })
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
      <input 
        type="text"
        name="search"
        class="form-control mb-2"
        :placeholder="$t('picker.parameters.search.placeholder')"
        v-model="parameters.search.term"
        @keyup="update">
    </div>
    <div
      v-for="filter in parameters.filters"
      :key="filter.name"
      class="mb-3">
      <b>{{ filter.name }}</b>
      <ValuesInFilter
        :values="filter.values"
        @change="update" />
    </div>
    <div
      class="mb-3"
      v-if="parameters.sort.values.length">
      <b>{{ $t('picker.parameters.sort')}}</b>
      <select
        class="form-select"
        v-model="parameters.sort.current"
        @change="update">
        <option
          v-for="sort in parameters.sort.values"
          :key="sort.id"
          :value="sort.id">
          {{ sort.name }}
        </option>
      </select>
    </div>
  </div>
</template>
