import { createApp } from "vue/dist/vue.esm-bundler.js";
import { VueDraggableNext } from "vue-draggable-next";

export default createApp({
    components: {
      draggable: VueDraggableNext.VueDraggableNext,
    },
    data() {
        return {
            fields: [],
            keys: { email: "Email", first_name: "Prénom" }
        };
        //   return {
        //     fields: <%= object.sso_mapping.blank? ? '[]' : object.sso_mapping.to_json.html_safe %>,
        //     keys: <%= mapping_keys.map { |key| [key, User.human_attribute_name(key)] }.to_h.to_json.html_safe %>
        //   }
    },
    methods: {
      addField: function () {
        this.fields.push({sso_key: 'key', internal_key: 'email', roles: {}});
        this.enableSelects();
      },
      enableSelects: function () {
        // conditional.js messes with the new field added, so we have to force enable the select fields
        var selectFields,
            i;
        setTimeout(function() {
          selectFields = this.$el.getElementsByClassName("form-select");
          for (i = 0; i < selectFields.length; i += 1) {
              target = selectFields[i];
              target.removeAttribute('disabled');
          }
        }, 100);
      }
    },
    mounted() {
        // this.enableSelects();
    }
});
