export default {
  props: {
    id: { type: String, required: true },
    endpoint: { type: String, required: true },
  },
  data() {
    return {
      resource: null,
      loading: true,
    };
  },
  watch: {
    id() {
      this.load();
    },
  },
  methods: {
    async load() {
      this.loading = true;
      this.resource = null;
      try {
        const url = this.endpoint + '/' + this.id + '.json';
        const res = await fetch(url);
        if (!res.ok) throw new Error(res.statusText);
        this.resource = await res.json();
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
      } finally {
        this.loading = false;
      }
    },
  },
  mounted() {
    this.load();
  },
};
