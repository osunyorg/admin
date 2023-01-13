/*global $, SummernoteAttachmentUpload */
$(function () {
    'use strict';

    var configs = [];

    configs['link'] = {
        toolbar: [
            ['insert', ['link', 'unlink']]
        ],
        followingToolbar: true,
        disableDragAndDrop: true
    };

    configs['mini'] = {
        toolbar: [
            ['font', ['bold', 'italic']],
            ['position', ['superscript', 'subscript']],
            ['insert', ['link', 'unlink']],
            ['view', ['codeview']]
        ],
        followingToolbar: true,
        disableDragAndDrop: true
    };

    configs['mini-list'] = {
        toolbar: [
            ['font', ['bold', 'italic']],
            ['position', ['superscript', 'subscript']],
            ['para', ['ul', 'ol']],
            ['insert', ['link', 'unlink']],
            ['view', ['codeview']]
        ],
        followingToolbar: true,
        disableDragAndDrop: true
    };


    configs['full'] = {
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
        disableDragAndDrop: true,
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

    $.extend($.summernote.lang['en-US'].image, {
        dragImageHere: 'Drag file here',
        dropImage: 'Drop file'
    });

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
    $("button[data-toggle='dropdown']").each(function (index) {
        $(this).removeAttr("data-toggle").attr("data-bs-toggle", "dropdown");
    });

    window.SUMMERNOTE_CONFIGS = configs;
});
