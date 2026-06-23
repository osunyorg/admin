<script>
import { CircleQuestionMark } from '@lucide/vue';
export default {
  name: 'DomCount',
  props: [
    'count',
    'i18n'
  ],
  components: {
    CircleQuestionMark,
  },
  computed: {
    level() {
      if (this.$props.count < this.level_one) {
        return 'one';
      } else if (this.$props.count < this.level_two) {
        return 'two';
      } else if (this.$props.count < this.level_three) {
        return 'three';
      } else if (this.$props.count < this.level_four) {
        return 'four';
      } else {
        return 'five';
      }
    },
    roundedCount() {
      return Math.round(this.$props.count / this.rounding_step) * this.rounding_step;
    },
    countSentence() {
      return this.$props.i18n.blocksEditor.dom_count.count.replace('{count}', this.roundedCount);
    },
  },
  data () {
    return {
      // Beware if you change levels, there are texts in the i18n files!
      level_one: 300,
      level_two: 600,
      level_three: 1000,
      level_four: 2000,
      levels: ['one', 'two', 'three', 'four', 'five'],
      // Affichage arrondi pour ne pas donner un faux sentiment de précision
      rounding_step: 50,
    }
  },
};
</script>

<template>
  <div class="row mt-5">
    <div class="offset-lg-4 col-lg-8 col-xxl-6">
      <div class="vue__dom-count">
        <div class="vue__dom-count__information">
          <div class="vue__dom-count__information__button">
            <button data-bs-toggle="collapse" data-bs-target="#dom-count-information">
              {{ i18n.blocksEditor.dom_count.more.title }}
              <CircleQuestionMark />
            </button>
          </div>
          <div class="collapse vue__dom-count__information__content" id="dom-count-information">
            <h2>{{ i18n.blocksEditor.dom_count.more.title }}</h2>
            <div v-html="i18n.blocksEditor.dom_count.more.explanation"></div>
            <ol>
              <li v-for="level in levels">
                <img :src="`/dom_count/${level}.png`" class="vue__dom-count__image img-fluid" alt="" />
                <div>
                  <p class="vue__dom-count__information__content__title">
                    {{ i18n.blocksEditor.dom_count.level[level].title }}
                  </p>
                  <p class="vue__dom-count__information__content__text">
                    {{ i18n.blocksEditor.dom_count.level[level].dom }}
                  </p>
                </div>
              </li>
            </ol>
            <hr>
          </div>
        </div>
        <div class="row">
          <div class="col-md-5">
            <img :src="`/dom_count/${level}.png`" class="vue__dom-count__image img-fluid" alt="" />
          </div>
          <div class="col-md-7">
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
