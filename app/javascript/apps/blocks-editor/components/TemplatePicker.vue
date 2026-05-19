<script>
// Vue-native template picker. Fetches the available block templates as JSON
// from the server (filtered server-side via `allowed_for_about?`), renders
// them as a grid in pure Vue, and POSTs to create a block when a card is
// clicked. On 201 it emits `created` with the new block's edit URL so the
// parent can swap us out for the editor.

export default {
  name: 'TemplatePicker',
  props: {
    url: { type: String, required: true },
    csrfToken: { type: String, required: true },
  },
  emits: ['created'],
  data() {
    return {
      loading: true,
      categories: [],
      aboutType: null,
      aboutId: null,
      createUrl: '',
      buttonLabel: '',
      submitting: false,
    };
  },
  watch: {
    url: {
      handler(newUrl) {
        if (newUrl) this.load();
      },
      immediate: true,
    },
  },
  methods: {
    async load() {
      this.loading = true;
      try {
        const res = await fetch(this.url, { headers: { Accept: 'application/json' } });
        const data = await res.json();
        this.aboutType = data.about_type;
        this.aboutId = data.about_id;
        this.createUrl = data.create_url;
        this.buttonLabel = data.button_label;
        this.categories = data.categories;
      } finally {
        this.loading = false;
      }
    },
    async pick(template) {
      if (this.submitting) return;
      this.submitting = true;
      try {
        const res = await fetch(this.createUrl, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': this.csrfToken,
            Accept: 'application/json',
          },
          body: JSON.stringify({
            communication_block: {
              about_type: this.aboutType,
              about_id: this.aboutId,
              template_kind: template.kind,
            },
          }),
        });
        if (res.status === 201) {
          const location = res.headers.get('Location');
          if (location) this.$emit('created', location);
        }
      } finally {
        this.submitting = false;
      }
    },
  },
};
</script>

<template>
  <div v-if="loading" class="text-center py-5">
    <div class="spinner-border text-primary" role="status" />
  </div>
  <template v-else>
    <section
      v-for="category in categories"
      :key="category.key"
      class="blocks">
      <p class="float-end blocks__category__description">{{ category.description }}</p>
      <h2 class="h3 category blocks__category__title">{{ category.label }}</h2>
      <div class="row">
        <div
          v-for="template in category.templates"
          :key="template.kind"
          class="col-md-4 col-6 d-flex mb-5">
          <div class="flex-fill position-relative">
            <img
              :src="template.thumbnail_url"
              alt=""
              class="card-img-top block__image" />
            <div>
              <h3 class="h4 block__title">{{ template.name }}</h3>
              <p class="mb-0 block__description">{{ template.description }}</p>
              <button
                type="button"
                class="btn btn-light mb-2 stretched-link mt-2"
                :disabled="submitting"
                @click="pick(template)">
                {{ buttonLabel }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  </template>
</template>
