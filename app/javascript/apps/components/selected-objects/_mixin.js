export default {
  props: {
    id: { type: String, required: true },
    endpoint: { type: String, required: true },
  },
  emits: [
    'loaded'
  ],
  data() {
    return {
      resource: null,
      loading: true,
    };
  },
  computed: {
    url() {
      return this.endpoint + '/' + this.id + '.json';
    }
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
      if (this.id == '') {
        return;
      }
      try {
        const res = await fetch(this.url);
        if (!res.ok) throw new Error(res.statusText);
        this.resource = await res.json();
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(error);
      } finally {
        this.loading = false;
        this.$emit('loaded', this.resource);
      }
    },
  },
  mounted() {
    this.load();
  },
};
