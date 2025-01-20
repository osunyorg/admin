<script>
import { Upload } from 'lucide-vue-next';

export default {
  components: { 
    Upload
  },
  props: [
    'target'
  ],
  data () {
    return {
      url: "/rails/active_storage/direct_uploads",
      input: {
        field: null,
        object: null,
      },
      file: {
        size: {
          bytes: null,
          mo: null,
        },
      },
      size: {
        max: {
          bytes: 5242880,
          mo: 5242880 / 1024 / 1024, // 5 Mo
        },
        alert: {
          active: false,
          sentence: '',
        },
      },
      blob: {
        id: null,
        signed_id: null,
        checksum: null,
      },
      directUpload: null,
    }
  },
  methods: {
    uploadInputChanged(event) {
      var files = event.target.files || event.dataTransfer.files;
      if (!files.length) {
        return;
      }
      this.input.field = event.target;
      this.input.object = files[0];
      this.checkSize();
      if (!this.size.alert.active) {
        this.uploadFile();
      }
    },
    checkSize() {
      this.file.size.bytes = this.input.object.size;
      this.file.size.mo = Math.round(this.file.size.bytes / 1024 / 1024);
      if (this.file.size.bytes > this.size.max.bytes) {
        this.size.alert.active = true;
        this.size.alert.sentence = "Le fichier est trop lourd ! (" + this.file.size.mo + " Mo > " + this.size.max.mo + " Mo)",
        alert(this.size.alert.sentence);
      }
    },
    uploadFile() {
      this.directUpload = new ActiveStorage.DirectUpload(this.input.object, this.url, this);
      this.directUpload.create(function (error, blob) {
        if (error) {
          console.error(error);
        } else {
          this.blob.id = blob.id;
          this.blob.signed_id = blob.signed_id;
          this.blob.checksum = blob.checksum;
          this.blob.url = "/media/" + this.blob.signed_id + "/preview.jpg";
          this.$emit('uploaded', this.blob);
        }
      }.bind(this));
    },
  },
  mounted() {
  }
};
</script>

<template>
  <div class="image-picker__selector__viewport">
    <input  hidden
            ref="file"
            type="file"
            accept="<%= default_images_formats_accepted %>"
            v-on:change="uploadInputChanged($event)">
    <button type="button"
            class="btn"
            v-on:click.prevent="$refs.file.click()">
      <Upload stroke-width="1.5" />
      <%= t 'photo_import.buttons.upload' %>
    </button>
    <div class="form-text">Fichiers .jpg, .jpeg, .png, .svg uniquement. 5 Mo max.</div>
  </div>
</template>