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
      if (this.$props.count < this.threshold_one) {
        return 'one';
      } else if (this.$props.count < this.threshold_two) {
        return 'two';
      } else if (this.$props.count < this.threshold_three) {
        return 'three';
      } else if (this.$props.count < this.threshold_four) {
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
    },
  },
  data () {
    return {
      threshold_one: 300,
      threshold_two: 600,
      threshold_three: 1000,
      threshold_four: 2000,
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
              {{ i18n.blocksEditor.dom_count.more.button }}
              <CircleQuestionMark />
            </button>
          </div>
          <div class="collapse vue__dom-count__information__content" id="dom-count-information">
            <h2>{{ i18n.blocksEditor.dom_count.more.button }}</h2>
            <p>
              Une page Web est composée d'un ensemble d'éléments. 
              Un paragraphe de texte est un élément, un lien à l'intérieur de ce texte est un autre élément, un mot en italique constitue un troisième élément. 
              Cela ne présage pas du poids de la page, parce qu'un élément img peut appeler une image qui pèse plusieurs mégaoctets, et qu'un seul paragraphe peut contenir tous les livres de Balzac bout à bout. 
              En code, on interagit avec ces éléments via un modèle de document, le DOM (Document Object Model).
            </p>
            <p>
              Le score EcoIndex accorde une très grande importance à la taille du DOM pour calculer la qualité écologique d'une page. 
              L'idée sous-jacente est qu'un DOM plus grand va nécessiter plus d'énergie du périphérique pour être rendu, et affiché dans le navigateur. 
              Si cette idée est juste théoriquement, elle passe à côté du plus gros consommateur d'énergie du périphérique : le JavaScript.
              Ainsi, il suffit d'une animation gourmande ou d'un objet 3D pour que le JavaScript transforme votre ordinateur en ventilateur ou votre téléphone mobile en chaufferette. 
              Pour en savoir plus, consultez l'article <a href="https://www.osuny.org/actualites/2026-06-03-osuny-et-le-score-ecoindex/" target="_blank">osuny et le score EcoIndex</a>.
            </p>
            <p>
              Néanmoins, le nombre d'éléments du DOM est un élément intéressant en termes de sobriété éditoriale. 
              Il s'agit, non pas d'essayer de mesurer l'impact écologique, mais d'évaluer l'effet sur l'attention.
              Là non plus, ce n'est pas très exact, par exemple, si vous utilisez des titres repliés, vous ne saturez pas l'attention de la personne de la même manière que si le contenu est directement affiché.
              Mais il est souhaitable de se demander si le contenu est à la fois aussi petit que possible, et aussi gros que nécessaire. 
              Qu'il n'y en a ni trop, ni trop peu. 
            </p>
            <p>
              Pour cela, osuny s'appuie sur les blocs utilisés pour calculer approximativement le nombre d'éléments de la page.
              Ce nombre d'éléments est ensuite traduit en cinq palliers, présentés ci-dessous. 
              Aucun de ces palliers n'est bon ou mauvais en soi, c'est purement une question d'adéquation aux usages.
              Une des méthodes permettant d'évaluer la pertinence des pages denses est de vérifier que le temps passé sur ces pages par les internautes est significatif. 
              Pour les pages très simples, il s'agit d'évaluer si les personnes trouvent l'information qu'elles cherchent, ou si elles sont contraintes de charger d'autres pages. 
              Le travail d'écoconception est subtil, et il s'appuie toujours sur l'écoute des personnes et l'observation des usages. 
            </p>
            <ol>
              <li>
                <img class="vue__dom-count__image img-fluid" src="/dom_count/one.png" alt="" />
                <div>
                  <p class="vue__dom-count__information__content__title">
                    {{ i18n.blocksEditor.dom_count.level.one.title }}
                  </p>
                  <p class="vue__dom-count__information__content__text">
                    Moins de {{ threshold_one }} éléments dans le DOM
                  </p>
                </div>
              </li>
              <li>
                <img class="vue__dom-count__image img-fluid" src="/dom_count/two.png" alt="" />
                <div>
                  <p class="vue__dom-count__information__content__title">
                    {{ i18n.blocksEditor.dom_count.level.two.title }}
                  </p>
                  <p class="vue__dom-count__information__content__text">
                    Entre {{ threshold_one }} et {{ threshold_two }} éléments dans le DOM
                  </p>
                </div>
              </li>
              <li>
                <img class="vue__dom-count__image img-fluid" src="/dom_count/three.png" alt="" />
                <div>
                  <p class="vue__dom-count__information__content__title">
                    {{ i18n.blocksEditor.dom_count.level.three.title }}
                  </p>
                  <p class="vue__dom-count__information__content__text">
                    Entre {{ threshold_two }} et  {{ threshold_three }} éléments dans le DOM
                  </p>
                </div>
              </li>
              <li>
                <img class="vue__dom-count__image img-fluid" src="/dom_count/four.png" alt="" />
                <div>
                  <p class="vue__dom-count__information__content__title">
                    {{ i18n.blocksEditor.dom_count.level.four.title }}
                  </p>
                  <p class="vue__dom-count__information__content__text">
                    Entre {{ threshold_three }} et {{ threshold_four }} éléments dans le DOM
                  </p>
                </div>
              </li>
              <li>
                <img class="vue__dom-count__image img-fluid" src="/dom_count/five.png" alt="" />
                <div>
                  <p class="vue__dom-count__information__content__title">
                    {{ i18n.blocksEditor.dom_count.level.five.title }}
                  </p>
                  <p class="vue__dom-count__information__content__text">
                    Plus de {{ threshold_four }} éléments dans le DOM
                  </p>
                </div>
              </li>
            </ol>
            <hr>
          </div>
        </div>
        <div class="row">
          <div class="col-md-5">
            <img class="vue__dom-count__image img-fluid" :src="`/dom_count/${level}.png`" alt="" />
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