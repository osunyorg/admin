<script>
export default {
  name: 'DomCount',
  props: ['count'],
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
            <p class="vue__dom-count__title">Coquelicot</p>
            <p class="vue__dom-count__count">Environ {{ roundedCount }} éléments dans le DOM</p>
            <p class="vue__dom-count__text">Cette page web est extrêmement simple ! C'est probablement une très bonne chose, si ça correspond bien à l'usage des internautes. Mais il faut aussi se demander si cela ne les oblige pas à charger plusieurs pages pour trouver l'information souhaitée. Une page bien écoconçue, c'est une page qui répond aux besoins des personnes, ni plus ni moins.</p>
            <p class="vue__dom-count__credit">
              Illustration :<br>
              Botanique élémentaire : organographie et classification<br>
              Ferdinand Faideau (1862-193.)<br>
              Source gallica.bnf.fr / Bibliothèque nationale de France
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>