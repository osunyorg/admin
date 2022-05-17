/*global $, SummernoteAttachmentUpload */
$(function () {
    'use strict';

    var configs = [];
    configs['mini'] = {
        toolbar: [
            ['font', ['bold', 'italic']],
            ['position', ['superscript', 'subscript']],
            ['insert', ['link']],
            ['view', ['codeview']]
        ]
    };

    configs['mini-list'] = {
        toolbar: [
            ['font', ['bold', 'italic']],
            ['position', ['superscript', 'subscript']],
            ['para', ['ul', 'ol']],
            ['insert', ['link']],
            ['view', ['codeview']]
        ]
    };

    configs['default'] = {
        popover: {
            image: [
                ['remove', ['removeMedia']]
            ]
        },
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'italic']],
            ['position', ['superscript', 'subscript']],
            ['para', ['ul', 'ol']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
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
        callbacks: {
            onImageUpload: function (files) {
                var attachmentUpload = new SummernoteAttachmentUpload(this, files[0]);
                attachmentUpload.start();
            },
            onMediaDelete: function (_, $editable) {
                $.summernote.rails.cleanEmptyAttachments($editable);
            },
            onKeyup: function (e) {
                var $editable = $(e.currentTarget);
                if (e.keyCode === 8) {
                    $.summernote.rails.cleanEmptyAttachments($editable);
                }
            }
        }
    };

    $.extend($.summernote.lang['en-US'].image, {
        dragImageHere: 'Drag file here',
        dropImage: 'Drop file'
    });

    $('[data-provider="summernote"]').each(function () {
        var config = $(this).attr('data-summernote-config');
        config = config || 'default';
        $(this).summernote(configs[config]);
    });

    window.SUMMERNOTE_CONFIGS = configs;
});
