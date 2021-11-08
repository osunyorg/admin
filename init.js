/*global window, document, $ */
window.b2bylon.training.paths = {
    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    },

    init: function () {
        'use strict';

        this.$kindSelect = $('select#features_training_path_kind');
        if (!this.$kindSelect.length) {
            return;
        }
        this.$folderKindForms = $('.kind-folder');
        this.$activityKindForms = $('.kind-activity');
        this.$activityField = $('input#features_training_path_activity_uid');
        this.$kindSelect.on('change', this.kindChanged.bind(this));

        this.kindChanged();
    },

    kindChanged: function () {
        'use strict';
        if (this.$kindSelect.val() === 'activity') {
            this.$folderKindForms.hide();
            $('.form-group.required select, .form-group.required input', this.$folderKindForms).removeAttr('required');
            this.$activityKindForms.show();
            $('.form-group.required select, .form-group.required input', this.$activityKindForms).attr('required', 'required');
        } else {
            this.$folderKindForms.show();
            $('.form-group.required select, .form-group.required input', this.$folderKindForms).attr('required', 'required');
            this.$activityKindForms.hide();
            $('.form-group.required select, .form-group.required input', this.$activityKindForms).removeAttr('required', 'required');
        }
    }

}.invoke();


document.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.b2bylon.training.paths.init();
});
