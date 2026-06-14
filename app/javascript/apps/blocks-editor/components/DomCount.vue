<script>
export default {
  name: 'DomCount',
  props: ['count']
};
</script>

<template>
  <div class="row mt-5">
    <div class="offset-lg-4 col-lg-8 col-xxl-6">
      <div class="vue__dom-count">
        <div class="row">
          <div class="col-md-3">
            <img class="vue__dom-count__image img-fluid" src="/dom_count/coquelicot.jpg" alt="" />
          </div>
          <div class="offset-md-1 col-md-8">
            <p class="vue__dom-count__title">Coquelicot</p>
            <p class="vue__dom-count__text">Cette page web est extrêmement légère ! C'est probablement une très bonne chose, si ça correspond bien à l'usage des internautes. Mais il faut aussi se demander si cela ne les oblige pas à charger plusieurs pages pour trouver l'information souhaitée. Une page bien écoconçue, c'est une page qui répond aux besoins des personnes, ni plus ni moins.</p>
            <p class="vue__dom-count__count">Environ {{ count }} éléments dans le DOM</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>