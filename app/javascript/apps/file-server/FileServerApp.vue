<script>
export default {
  data() {
    return {
      data: {},
      permalinkChanged: false,
      redirection: '',
    };
  },
  methods: {
    async load() {
      await this.request(this.endpoint);
    },
    blockInvalidPermalinkChars(event) {
      // Empêche l'insertion avant qu'elle n'atteigne le DOM, pour éviter
      // le clignotement d'un caractère invalide le temps que `parsePermalink`
      // (déclenché après coup par @input) le retire.
      if (event.data && /[^a-zA-Z0-9-]/.test(event.data)) {
        event.preventDefault();
      }
    },
    parsePermalink(event) {
      this.data.file_server.slug = event.target.value
        .toLowerCase()
        .replace(/[^a-z0-9-]/g, '');
      this.permalinkChanged = true;
    },
    async savePermalink() {
      const json = await this.request(this.data.file_server.endpoint, {
        method: 'PATCH',
        body: { file_server_slug: this.data.file_server.slug },
      }, this.$t('fileServer.permalink.changed'));
      if (json) this.permalinkChanged = false;
    },
    parseRedirection(event) {
      // TODO filtre
      this.redirection = event.target.value;
    },
    async addRedirection() {
      await this.request(this.data.redirections.endpoint, {
        method: 'POST',
        body: { path_without_extension: this.redirection },
      }, this.$t('fileServer.redirections.added'));
    },
    async removeRedirection(redirection) {
      await this.request(redirection.endpoint, {
        method: 'DELETE',
      }, this.$t('fileServer.redirections.removed'));
    },
    async request(url, options = {}, successMessage = null) {
      try {
        const response = await fetch(url, {
          method: options.method || 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': this.csrfToken,
          },
          body: options.body ? JSON.stringify(options.body) : undefined,
        });
        const json = await response.json();
        if (!response.ok) {
          this.notify(json.error, 'error');
          return null;
        }
        this.data = json;
        if (successMessage) this.notify(successMessage, 'success');
        return json;
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
        this.notify(this.$t('fileServer.error'), 'error');
        return null;
      }
    },
    notify(message, type) {
      const notyf = new Notyf();
      notyf.open({
        message: message,
        type: type,
        position: { x: 'left', y: 'bottom' },
        duration: 9000,
        ripple: true,
        dismissible: true,
      });
    },
  },
  beforeMount() {
    this.csrfToken = document.querySelector('[name="csrf-token"]').content;
    this.dataset = document.getElementById('file-server-app').dataset;
    this.endpoint = this.dataset.endpoint;
  },
  mounted() {
    this.load();
  },
};
</script>

<template>
  <section class="mb-5">
    <h2>{{ $t('fileServer.permalink.title') }}</h2>
    <div class="card card--horizontal mt-2">
      <div class="card-body">
        <div class="d-lg-flex align-items-center">
          <span class="me-1 text-muted">
            {{ data.file_server?.base_url }}
          </span>
          <input
            type="text"
            class="form-control"
            :value="data.file_server?.slug"
            @beforeinput="blockInvalidPermalinkChars"
            @input="parsePermalink"
            />
          <span class="ms-2 me-5 text-muted">
            {{ data.file_server?.extension }}
          </span>
        </div>
      </div>
      <div class="card-footer">
        <button
          type="button"
          class="btn btn-light text-nowrap me-2"
          :disabled="!this.permalinkChanged"
          @click.prevent="savePermalink"
          >
          {{ $t('fileServer.permalink.save') }}
        </button>
        <a
          class="btn btn-light text-nowrap"
          :href="data.file_server?.url"
          target="_blank"
          >
          {{ $t('fileServer.permalink.open') }}
        </a>
      </div>
    </div>

    <div class="mt-4">
      {{ $t('fileServer.redirections.title') }}
      <div class="row g-2">
        <div v-for="redirection in data.redirections?.list">
          <div class="card card--horizontal">
            <div class="card-body">
              <p class="my-2">
                {{ redirection.url }}
              </p>
            </div>
            <div class="card-footer">
              <button
                type="button"
                class="btn btn-danger text-nowrap me-2"
                @click.prevent="removeRedirection(redirection)"
                >
                {{ $t('fileServer.redirections.remove') }}
              </button>
              <a
                class="btn btn-light text-nowrap"
                :href="redirection.url"
                target="_blank"
                >
                {{ $t('fileServer.redirections.open') }}
              </a>
            </div>
          </div>
        </div>
        <div>
          <div class="card card--horizontal">
            <div class="card-body">
              <div class="button-group d-lg-flex align-items-center">
                <span class="me-1 text-muted">
                  {{ data.redirections?.base_url }}
                </span>
                <input
                  type="text"
                  class="form-control"
                  @input="parseRedirection"
                  />
                <span class="ms-2 me-5 text-muted">
                  {{ data.file_server?.extension }}
                </span>
                <div class="card-footer p-0">
                  <button
                    type="button"
                    class="btn btn-light text-nowrap"
                    :disabled="this.redirection == ''"
                    @click.prevent="addRedirection"
                    >
                    {{ $t('fileServer.redirections.add') }}
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
