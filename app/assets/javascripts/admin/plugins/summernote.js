/*global $, SummernoteAttachmentUpload */
$(function () {
    'use strict';

    $.extend($.summernote.lang['en-US'].image, {
        dragImageHere: 'Drag file here',
        dropImage: 'Drop file'
    });

    $('[data-provider="summernote"]').each(function () {
        $(this).summernote({
            popover: {
                image: [
                    ['remove', ['removeMedia']]
                ]
            },
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic']],
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
        });
    });
});
