<script>
export default {
  name: 'DomCount',
  props: [
    'count',
    'i18n'
  ],
  computed: {
    level() {
      if (this.$props.count < 300) {
        return 'one';
      } else if (this.$props.count < 600) {
        return 'two';
      } else if (this.$props.count < 1000) {
        return 'three';
      } else if (this.$props.count < 2000) {
        return 'four';
      } else {
        return 'five';
      }
    },
    roundedCount() {
      return Math.round(this.$props.count/50)*50;
    },
    countSentence() {
      return this.$props.i18n.blocksEditor.dom_count.count.replace('{count}', this.roundedCount);
    }
  },
};
</script>

<template>
  <div class="row mt-5">
    <div class="offset-lg-4 col-lg-8 col-xxl-6">
      <div class="vue__dom-count">
        <div class="row">
          <div class="col-md-4">
            <img class="vue__dom-count__image img-fluid" :src="`/dom_count/${level}.png`" alt="" />
          </div>
          <div class="col-md-8">
            <p class="vue__dom-count__title">
              {{ i18n.blocksEditor.dom_count.level[level].title }}
            </p>
            <p class="vue__dom-count__count">
              {{ countSentence }}
            </p>
            <p class="vue__dom-count__text">
              {{ i18n.blocksEditor.dom_count.level[level].text }}
            </p>
            <p class="vue__dom-count__credit" v-html="i18n.blocksEditor.dom_count.credit"></p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>