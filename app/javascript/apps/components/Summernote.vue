<script>
export default {
    props: [
      'modelValue',
      'lang'
    ],
    emits: ['update:modelValue'],
    computed: {
      value: {
        get() {
          return this.modelValue;
        },
        set(value) {
          this.handle();
          this.$emit('update:modelValue', value);
        }
      },
    },
    data () {
      return {
      }
    },
    methods: {
      handle() {
        if (this.isConfigReady()) {
          this.initAllInstances();
        } else {
          setTimeout(this.handle, 100, this);
        }
      },
      isConfigReady() {
        return window.SUMMERNOTE_CONFIGS;
      },
      initAllInstances() {
        var $summernoteElements = $('.vue__summernote:not(.vue__summernote--initialized)');
        $summernoteElements.each(function(index) {
          var element = $summernoteElements.get(index);
          this.init(element);
        }.bind(this));
      },
      init(element) {
        element.classList.add('vue__summernote--initialized');
        $(element).summernote({
          lang: this.lang,
          toolbar: window.SUMMERNOTE_CONFIGS['link'].toolbar,
          callbacks: {
            onPaste: window.SUMMERNOTE_CONFIGS['link'].callbacks.onPaste,
            onChange: function(content) {
              element.value = content;
              element.dispatchEvent(new Event('input'));
            },
          }
        });
      },
    },
    updated: function() {
      this.handle();
    },
    mounted: function() {
      this.handle();
    },
};
</script>

<template>
  <textarea 
    class="form-control vue__summernote"
    data-translatable="true"
    v-model="value"></textarea>
</template>
