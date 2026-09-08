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
      try {
        const response = await fetch(this.endpoint);
        if (!response.ok) throw new Error(response.statusText);
        this.data = await response.json();
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
      }
    },
    parsePermalink(event) {
      // TODO filtre
      this.data.file_server.slug = event.target.value;
      this.permalinkChanged = true;
    },
    async savePermalink() {
      const response = await fetch(this.data.file_server.endpoint, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
        },
        body: JSON.stringify({
          file_server_slug: this.data.file_server.slug
        }),
      });
      if (!response.ok) {
        throw new Error(response.statusText);
      } else {
        this.permalinkChanged = false;
        this.data = await response.json();
        this.notify(this.$t('fileServer.permalink.changed'));
      }
    },
    parseRedirection(event) {
      // TODO filtre
      this.redirection = event.target.value;
    },
    async addRedirection() {
      const response = await fetch(this.data.redirections.endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
        },
        body: JSON.stringify({
          path_without_extension: this.redirection
        }),
      });
      if (!response.ok) {
        throw new Error(response.statusText);
      } else {
        this.data = await response.json();
        this.notify(this.$t('fileServer.redirections.added'));
      }
    },
    async removeRedirection(redirection) {
      const response = await fetch(redirection.endpoint, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken,
        },
      });
      if (!response.ok) {
        throw new Error(response.statusText);
      } else {
        this.data = await response.json();
        this.notify(this.$t('fileServer.redirections.removed'));
      }
    },
    notify(message) {
      const notyf = new Notyf();
      notyf.open({
        type: 'success',
        position: { x: 'left', y: 'bottom' },
        message: message,
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
            {{ redirection.url }}
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
</template>
