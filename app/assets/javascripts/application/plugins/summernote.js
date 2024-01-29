/*global $ */
window.summernoteManager = {
    configs: {},

    init: function () {
        'use strict';
        this.setConfigs();
        this.initEditors();
        this.monkeyPatchDropdownButtons();
    },

    setConfigs: function () {
        'use strict';
        this.setConfig('link', {
            toolbar: [
                ['insert', ['link', 'unlink']]
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['a'], ['href', 'target'])
            }
        });

        this.setConfig('mini', {
            toolbar: [
                ['font', ['bold', 'italic']],
                ['position', ['superscript']],
                ['insert', ['link', 'unlink']],
                ['view', ['codeview']]
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['b', 'strong', 'i', 'em', 'sup', 'a'], ['href', 'target'])
            }
        });

        this.setConfig('mini-list', {
            toolbar: [
                ['font', ['bold', 'italic']],
                ['position', ['superscript']],
                ['para', ['ul', 'ol']],
                ['insert', ['link', 'unlink']],
                ['view', ['codeview']]
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['b', 'strong', 'i', 'em', 'sup', 'a', 'ul', 'ol', 'li'], ['href', 'target'])
            }
        });

        this.setConfig('default', {
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic']],
                ['position', ['superscript', 'subscript']],
                ['para', ['ul', 'ol']],
                ['view', ['codeview']]
            ],
            styleTags: [
                'p',
                'blockquote',
                'pre',
                'h2',
                'h3',
                'h4'
            ],
            followingToolbar: true,
            disableDragAndDrop: true,
            callbacks: {
                onPaste: this.pasteSanitizedClipboardContent.bind(this, ['b', 'strong', 'i', 'em', 'sup', 'sub', 'a', 'ul', 'ol', 'li', 'p', 'blockquote', 'pre', 'h2', 'h3', 'h4'], ['href', 'target'])
            }
        });

        window.SUMMERNOTE_CONFIGS = this.configs;
    },

    setConfig: function (key, data) {
        'use strict';
        this.configs[key] = data;
    },

    initEditors: function () {
        'use strict';
        $('[data-provider="summernote"]').each(this.initEditor.bind(this));
    },

    initEditor: function (_, element) {
        'use strict';
        var config = $(element).attr('data-summernote-config'),
            locale = $('#summernote-locale').data('locale'),
            options = {};
        config = config || 'default';
        options = this.configs[config];
        // if locale is undefined, summernote use default (en-US)
        options['lang'] = locale;
        $(element).summernote(options);
    },

    monkeyPatchDropdownButtons: function () {
        'use strict';
        // https://github.com/summernote/summernote/issues/4170
        $('button[data-toggle="dropdown"]').each(function () {
            $(this).removeAttr('data-toggle')
                .attr('data-bs-toggle', 'dropdown');
        });
    },

    pasteSanitizedClipboardContent: function (allowedTags, allowedAttributes, event) {
        'use strict';
        var text = event.originalEvent.clipboardData.getData('text/plain'),
            html = event.originalEvent.clipboardData.getData('text/html');

        event.preventDefault();
        if (html) {
            html = html.toString();
            html = this.cleanHtml(html);
            html = this.sanitizeTags(html, allowedTags);
            html = this.sanitizeAttributes(html, allowedAttributes);
            document.execCommand('insertHTML', false, html);
        } else {
            document.execCommand('insertText', false, text);
        }
    },

    cleanHtml: function (html) {
        'use strict';
        // remove all html comments, microsoft attributes, ensure regular quote, double quote, ellipsis, hyphen
        var htmlModified = html.replace(/<!\[if !supportLists[\s\S]*?endif\]>/g, '')
            .replace(/<!--[\s\S]*?-->/g, '')
            .replace(/( class=(")?Mso[a-zA-Z]+(")?)/g, ' ')
            .replace(/[\u2018\u2019\u201A]/g, '\'')
            .replace(/[\u201C\u201D\u201E]/g, '"')
            .replace(/\u2026/g, '...')
            .replace(/[\u2013\u2014]/g, '-');
        return htmlModified;
    },

    sanitizeTags: function (html, allowedTags) {
        'use strict';
        var allowedTagsRegex = allowedTags.map(function (e) {
                return '(?!' + e + ')';
            }).join(''),
            tagStripper = new RegExp('</?' + allowedTagsRegex + '\\w*\\b[^>]*>', 'ig');

        return html.replace(tagStripper, '');
    },

    sanitizeAttributes: function (html, allowedAttributes) {
        'use strict';
        var div = document.createElement('div');
        div.innerHTML = html;
        this.sanitizeElementAttributes(div, allowedAttributes);
        return div.innerHTML;
    },

    sanitizeElementAttributes: function (elmt, allowedAttributes) {
        'use strict';
        var children = elmt.children,
            child,
            i,
            j;
        for (i = 0; i < children.length; i += 1) {
            child = children[i];
            for (j = child.attributes.length - 1; j >= 0; j -= 1) {
                if ($.inArray(child.attributes[j].name, allowedAttributes) < 0) {
                    child.removeAttributeNode(child.attributes[j]);
                }
            }

            if (child.children.length) {
                this.sanitizeElementAttributes(child, allowedAttributes);
            }
        }
    },

    invoke: function () {
        'use strict';
        return {
            init: this.init.bind(this)
        };
    }
};

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.summernoteManager.init();
});
