export default {
    props: {
        // Le modèle est l'identifiant
        // Ex: 7da86f39-08cc-490c-bef2-79323b397cf1
        modelValue: { type: String, default: '' },
        pickerEndpoint: { type: String, required: true },
        objectEndpoint: { type: String, required: true },
        label: { type: String, required: true },
        title: { type: String, required: true },
    },
    emits: ['update:modelValue'],
    computed: {
        hasValue() {
        return this.modelValue !== '';
        },
    },
    methods: {
        select(object) {
        this.$emit('update:modelValue', object.id);
        },
    }
};
