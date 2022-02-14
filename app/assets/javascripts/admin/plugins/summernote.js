/* eslint no-alert: 'off' */
/*global $, SummernoteAttachmentUpload */
$(function () {
    'use strict';

    $.extend($.summernote.lang['en-US'].image, {
        dragImageHere: 'Drag file here',
        dropImage: 'Drop file'
    });

    $.summernote.dom.isAttachment = function (node) {
        return node && (/^ACTION-TEXT-ATTACHMENT/).test(node.nodeName.toUpperCase());
    };

    $.summernote.dom.isInline = function (node) {
        return !this.isBodyContainer(node) &&
         !this.isList(node) &&
         !this.makePredByNodeName('HR')(node) &&
         !this.isPara(node) &&
         !this.makePredByNodeName('TABLE')(node) &&
         !this.makePredByNodeName('BLOCKQUOTE')(node) &&
         !this.makePredByNodeName('DATA')(node) &&
         !this.isAttachment(node);
    };

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
                    cleanupTest($editable);
                },
                onKeyup: function (e) {
                    // Delete
                    var $editable = $(e.currentTarget);
                    if (e.keyCode === 8) {
                        cleanupTest($editable);
                    }
                }
            }
        });
    });
});

function cleanupTest($field) {
    // $field.children
    console.log($field.children());
}
