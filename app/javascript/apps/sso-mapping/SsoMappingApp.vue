<script>
import { VueDraggableNext } from "vue-draggable-next";

const appElt = document.querySelector('#sso-mapping-app');

export default {
  components: {
    draggable: VueDraggableNext,
  },
  data () {
    return {
      fields: JSON.parse(appElt.dataset.fields),
      keys: JSON.parse(appElt.dataset.keys)
    }
  },
  methods: {
    addField: function () {
      this.fields.push({sso_key: 'key', internal_key: 'email', roles: {}});
      this.enableSelects();
    },
    enableSelects: function () {
      // conditional.js messes with the new field added, so we have to force enable the select fields
      var selectFields,
          target,
          i;
      setTimeout(function() {
        selectFields = document.getElementsByClassName("form-select");
        for (i = 0; i < selectFields.length; i += 1) {
          target = selectFields[i];
          target.removeAttribute('disabled');
        }
      }, 100);
    }
  },
  mounted() {
    this.enableSelects();
  }
};
</script>