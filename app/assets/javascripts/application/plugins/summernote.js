/*global $ */
window.summernoteManager = {
    configs: {},
    noteButton: function (context) {
        'use strict';
        var ui = $.summernote.ui,
            button = ui.button({
                contents: '<i class="fas fa-note-sticky"/>',
                tooltip: 'Note (beta)',
                className: 'note-btn-note',
                click: function () {
                    var text = context.invoke('editor.getSelectedText'),
                        // TODO find if it's a note or not
                        isANote = false,
                        note;
                    if (isANote) {
                        // TODO remove note
                    } else {
                        note = '<note>' + text + '</note>';
                        context.invoke('editor.pasteHTML', note);
                    }
                }
            });
        // return button as jquery object
        return button.render();
    },
    qButton: function (context) {
        'use strict';
        var ui = $.summernote.ui,
            button = ui.button({
                contents: '<i class="fas fa-quote-left"/>',
                tooltip: 'Quote',
                className: 'note-btn-quote',
                click: function () {
                    var range = context.invoke('editor.createRange');
                    var selectedText = range.toString();
                    if (selectedText) {
                        // Si du texte est sélectionné, le remplacer par <q>texte</q>
                        context.invoke('editor.pasteHTML', `<q>${selectedText}</q>`);
                    } else {
                        // Si aucun texte sélectionné, insérer <q> et placer le curseur dedans
                        var qNode = document.createElement('q');
                        qNode.innerHTML = '&#8203;'; // Caractère invisible pour éviter un q vide inaccessible
                        range.insertNode(qNode);

                        // Placer le curseur à l'intérieur du q
                        var newRange = document.createRange();
                        newRange.setStart(qNode, 0);
                        newRange.setEnd(qNode, 0);
                        var sel = window.getSelection();
                        sel.removeAllRanges();
                        sel.addRange(newRange);

                        context.invoke('editor.focus');
                    }
                }
            });
        // return button as jquery object
        return button.render();
    },
    init: function () {
        'use strict';
        this.setConfigs();
        this.initEditors();
        this.monkeyPatchDropdownButtons();
    },

    setConfigs: function () {
        'use strict';
        this.setConfig('nothing',
            {
                toolbar: []
            },
            [],
            []);

        this.setConfig('link',
            {
                toolbar: [
                    ['insert', ['link', 'unlink']]
                ]
            },
            ['a'],
            ['href', 'target']);

        this.setConfig('mini',
            {
                toolbar: [
                    ['font', ['bold', 'italic']],
                    ['position', ['superscript']],
                    ['insert', ['link', 'unlink']],
                    ['view', ['codeview']]
                ]
            },
            ['b', 'strong', 'i', 'em', 'sup', 'a'],
            ['href', 'target']);

        this.setConfig('mini-list',
            {
                toolbar: [
                    ['font', ['bold', 'italic']],
                    ['position', ['superscript']],
                    ['para', ['ul', 'ol']],
                    ['insert', ['link', 'unlink']],
                    ['view', ['codeview']]
                ]
            },
            ['b', 'strong', 'i', 'em', 'sup', 'a', 'ul', 'ol', 'li'],
            ['href', 'target']);

        this.setConfig('mini-list-with-notes',
            {
                toolbar: [
                    ['font', ['bold', 'italic', 'superscript', 'q']],
                    ['para', ['ul', 'ol']],
                    ['insert', ['link', 'unlink', 'note']],
                    ['view', ['codeview']]
                ]
            },
            ['b', 'strong', 'i', 'em', 'q', 'sup', 'a', 'ul', 'ol', 'li', 'note'],
            ['href', 'target']);

        this.setConfig('default',
            {
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
                ]
            },
            ['b', 'strong', 'i', 'em', 'sup', 'sub', 'a', 'ul', 'ol', 'li', 'p', 'blockquote', 'pre', 'h2', 'h3', 'h4'],
            ['href', 'target']);

        window.SUMMERNOTE_CONFIGS = this.configs;
    },

    setConfig: function (key, config, tags, attributes) {
        'use strict';
        config.followingToolbar = true;
        config.disableDragAndDrop = true;
        config.callbacks = {
            onPaste: this.pasteSanitizedClipboardContent.bind(this, tags, attributes)
        };
        this.configs[key] = config;
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
        var cleanedHtml,
            previousHtml;
        // remove allMicrosoft Office tag
        cleanedHtml = html.replace(/<!\[if !supportLists[\s\S]*?endif\]>/g, '');
        // remove all html comments
        do {
            previousHtml = cleanedHtml;
            cleanedHtml = cleanedHtml.replace(/<!--[\s\S]*?-->/g, '');
        } while (cleanedHtml !== previousHtml);
        // remove all microsoft attributes,
        cleanedHtml = cleanedHtml.replace(/( class=(")?Mso[a-zA-Z]+(")?)/g, ' ');
        // ensure regular quote
        cleanedHtml = cleanedHtml.replace(/[\u2018\u2019\u201A]/g, '\'');
        // ensure regular double quote
        cleanedHtml = cleanedHtml.replace(/[\u201C\u201D\u201E]/g, '"');
        // ensure regular ellipsis
        cleanedHtml = cleanedHtml.replace(/\u2026/g, '...');
        // ensure regular hyphen
        cleanedHtml = cleanedHtml.replace(/[\u2013\u2014]/g, '-');
        return cleanedHtml;
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
    }
};

window.addEventListener('DOMContentLoaded', function () {
    'use strict';
    window.summernoteManager.init();
});
