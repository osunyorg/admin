/*global define, module, require */
(function (factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['jquery'], factory);
    } else if (typeof module === 'object' && module.exports) {
        // Node/CommonJS
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals
        factory(window.jQuery);
    }
}(function ($) {
    'use strict';
    $.extend($.summernote.options, {
        stripTags: ['section', 'div', 'span', 'o', 'xml', 'font', 'style', 'embed', 'param', 'script', 'html', 'body', 'head', 'meta', 'title', 'link', 'iframe', 'abbr', 'acronym', 'address', 'applet', 'area', 'article', 'aside', 'audio', 'noframes', 'noscript', 'form', 'input', 'select', 'option', 'colgroup', 'col', 'std', 'xml:', 'st1:', 'o:', 'w:', 'v:'],
        onCleanHtml: function (html) {
            var htmlModified = html.replace(/<!\[if !supportLists[\s\S]*?endif\]>/g, '')
                .replace(/<!--[\s\S]*?-->/g, '')
                .replace(/( class=(")?Mso[a-zA-Z]+(")?)/g, ' ')
                .replace(/[\t ]+</g, '<')
                .replace(/>[\t ]+</g, '><')
                .replace(/>[\t ]+$/g, '>')
                .replace(/[\u2018\u2019\u201A]/g, '\'')
                .replace(/[\u201C\u201D\u201E]/g, '"')
                .replace(/\u2026/g, '...')
                .replace(/[\u2013\u2014]/g, '-');
            return htmlModified;
        }
    });

    $.extend($.summernote.plugins, {
        'striptags': function (context) {
            var $note = context.layoutInfo.note,
                $options = context.options;
            $note.on('summernote.paste', function (e, evt) {
                var text = evt.originalEvent.clipboardData.getData('text/plain'),
                    html = evt.originalEvent.clipboardData.getData('text/html'),
                    tagStripper = new RegExp('<[ /]*(' + $options.stripTags.join('|') + ')[^>]*>', 'gi'),
                    attributeStripper = /<(?!a)(\w+)[^>]*>/gi;
                evt.preventDefault();
                if (html) {
                    html = html.toString();
                    html = $options.onCleanHtml(html);
                    html = html.replace(attributeStripper, '<$1>');
                    html = html.replace(tagStripper, '');
                    document.execCommand('insertHTML', false, html);
                } else {
                    document.execCommand('insertHTML', false, text);
                }
                return false;
            });
        }
    });
}));
