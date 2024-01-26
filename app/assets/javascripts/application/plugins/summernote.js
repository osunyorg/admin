/*global $ */
$(function () {
    'use strict';

    var configs = [],
        cleanHtmlElementAttributes = function (elmt, allowedAttributes) {
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
                    cleanHtmlElementAttributes(child, allowedAttributes);
                }
            }
        },
        cleanHtmlAttributes = function (html, allowedAttributes) {
            var div = document.createElement('div');
            div.innerHTML = html;
            cleanHtmlElementAttributes(div, allowedAttributes);
            return div.innerHTML;
        },
        cleanHtmlTags = function (html, allowedTags) {
            var allowedTagsRegex = allowedTags.map(function (e) {
                    return '(?!' + e + ')';
                }).join(''),
                tagStripper = new RegExp('</?' + allowedTagsRegex + '\\w*\\b[^>]*>', 'ig');

            return html.replace(tagStripper, '');
        },
        cleanHtml = function (allowedTags, allowedAttributes, e) {
            var text = e.originalEvent.clipboardData.getData('text/plain'),
                html = e.originalEvent.clipboardData.getData('text/html');

            e.preventDefault();
            if (html) {
                html = html.toString();
                html = cleanHtmlTags(html, allowedTags);
                html = cleanHtmlAttributes(html, allowedAttributes);
                document.execCommand('insertHTML', false, html);
            } else {
                document.execCommand('insertText', false, text);
            }
        };

    configs['link'] = {
        toolbar: [
            ['insert', ['link', 'unlink']]
        ],
        followingToolbar: true,
        disableDragAndDrop: true,
        callbacks: {
            onPaste: cleanHtml.bind(this, ['a'], ['href', 'target'])
        }
    };

    configs['mini'] = {
        toolbar: [
            ['font', ['bold', 'italic']],
            ['position', ['superscript']],
            ['insert', ['link', 'unlink']],
            ['view', ['codeview']]
        ],
        followingToolbar: true,
        disableDragAndDrop: true
    };

    configs['mini-list'] = {
        toolbar: [
            ['font', ['bold', 'italic']],
            ['position', ['superscript']],
            ['para', ['ul', 'ol']],
            ['insert', ['link', 'unlink']],
            ['view', ['codeview']]
        ],
        followingToolbar: true,
        disableDragAndDrop: true
    };

    configs['full'] = {
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic']],
            ['position', ['superscript', 'subscript']],
            ['para', ['ul', 'ol']],
            ['table', ['table']],
            ['insert', ['link', 'unlink', 'picture', 'video']],
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
        disableDragAndDrop: true
    };


    configs['default'] = {
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
        disableDragAndDrop: true
    };

    $('[data-provider="summernote"]').each(function () {
        var config = $(this).attr('data-summernote-config'),
            locale = $('#summernote-locale').data('locale'),
            options = {};
        config = config || 'default';
        options = configs[config];
        // if locale is undefined, summernote use default (en-US)
        options['lang'] = locale;
        $(this).summernote(options);
    });

    // https://github.com/summernote/summernote/issues/4170
    $('button[data-toggle="dropdown"]').each(function () {
        $(this).removeAttr('data-toggle')
            .attr('data-bs-toggle', 'dropdown');
    });

    window.SUMMERNOTE_CONFIGS = configs;
});
