//= require codemirror/mode/xml/xml
//= require codemirror/mode/javascript/javascript
//= require codemirror/mode/css/css
//= require codemirror/mode/htmlmixed/htmlmixed
//= require codemirror/mode/sass/sass

/*global CodeMirror */

// Add [data-provider="codemirror"] to textarea.
// You need to set [data-codemirror-mode="<language>"] to set the language.
// You can use set [data-codemirror-indentation="n"] to set the indentation level (2 by default).
window.codemirrorManager = {
    init: function () {
        'use strict';
        var i;
        this.textareas = document.querySelectorAll('textarea[data-provider="codemirror"]');
        this.instances = [];
        for (i = 0; i < this.textareas.length; i += 1) {
            this.instances.push(this.createInstance(this.textareas[i]));
        }
    },

    createInstance: function (textarea) {
        'use strict';
        var config = this.defaultConfig(),
            mode = textarea.getAttribute('data-codemirror-mode'),
            indentationLevel = window.parseInt(textarea.getAttribute('data-codemirror-indentation'));

        if (isNaN(indentationLevel)) {
            indentationLevel = 2;
        }
        config['mode'] = mode;
        config['indentUnit'] = indentationLevel;
        return CodeMirror.fromTextArea(textarea, config);
    },

    defaultConfig: function () {
        return {
            lineNumbers: true,
            matchBrackets: true,
            styleActiveLine: true,
            indentUnit: 2,
            lineWrapping: true,
            viewportMargin: Infinity
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this),
            defaultConfig: this.defaultConfig.bind(this)
        };
    }
}.invoke();

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.codemirrorManager.init();
});
