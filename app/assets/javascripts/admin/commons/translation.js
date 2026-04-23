/* global $ */
window.osuny.translation = {
    init: function (scope) {
        'use strict';
        // scope defaults to document but can be narrowed when multiple
        // translation widgets coexist in the page (e.g. an about form +
        // a block edit offcanvas), since '#translation-button' is not unique.
        this.scope = scope || document;
        this.component = this.scope.querySelector('#translation-button');
        this.start = this.scope.querySelector('.js-translation-start');
        this.loader = this.scope.querySelector('.js-translation-loader');
        this.done = this.scope.querySelector('.js-translation-done');
        this.csrfToken = document.querySelector('[name="csrf-token"]').content;
        this.url = this.component.dataset.translationUrl;
        this.start.addEventListener('click', this.run.bind(this));
        this.maxLength = 5000;
    },

    run: function () {
        'use strict';
        this.start.hidden = true;
        this.loader.hidden = false;
        setTimeout(this.translateAllFields.bind(this), 100);
    },

    translateAllFields: function () {
        'use strict';
        var i,
            field;
        this.translatableFields = this.scope.querySelectorAll('[data-translatable]');
        for (i = 0; i < this.translatableFields.length; i += 1) {
            field = this.translatableFields[i];
            this.translate(field);
        }
        this.loader.hidden = true;
        let notyf = new Notyf();
        notyf.open({
            type: 'success',
            position: {
                x: 'left',
                y: 'bottom'
            },
            message: this.done.innerHTML,
            duration: 9000,
            ripple: true,
            dismissible: true
        });
    },

    translate: function (field) {
        'use strict';
        var text = field.value,
            length = text.length,
            xhr = new XMLHttpRequest(),
            that = this,
            data,
            translatedText;
        if (length > this.maxLength) {
            this.warnForTextTooLong(field);
        } else {
            xhr.open('POST', this.url, false);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.setRequestHeader('X-CSRF-Token', this.csrfToken);
            xhr.onreadystatechange = function () {
                if (this.readyState === 4 && this.status === 200 && this.responseText !== '') {
                    data = JSON.parse(this.responseText);
                    translatedText = data.translatedText;
                    that.translateField(field, translatedText);
                }
            };
            xhr.send(JSON.stringify({ text: text }));
        }
    },

    warnForTextTooLong: function (field) {
        'use strict';
        var element = field;
        if (this.isSummernote(field)) {
            element = field.parentNode.getElementsByClassName('note-editable')[0];
        }
        element.classList.add('border-danger');
    },

    translateField: function (field, text) {
        'use strict';
        if (this.isSummernote(field)) {
            $(field).summernote('code', text);
            // summernote.code() updates the editor + underlying textarea HTML
            // but does NOT fire the onChange callback, so any v-model wired
            // to the textarea stays out of sync. Set the value and dispatch
            // an input event so Vue's v-model picks up the translation.
            field.value = text;
            field.dispatchEvent(new Event('input'));
        } else {
            field.value = text;
            // https://stackoverflow.com/questions/56348513/how-to-change-v-model-value-from-js
            field.dispatchEvent(new Event('input'));
        }
    },

    isSummernote: function (field) {
        'use strict';
        return field.dataset.provider === 'summernote' || field.classList.contains('summernote-vue');
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
}.invoke();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    if (document.querySelector('#translation-button')) {
        window.osuny.translation.init();
    }
});
