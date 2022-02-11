/* eslint no-alert: 'off' */
/*global $, SummernoteAttachment, SummernoteAttachmentUpload */
// window.osuny.summernote.sendFile = function (file, toSummernote) {
//     'use strict';
//     var data = new FormData();
//     data.append('file', file);
//     $.ajax({
//         data: data,
//         type: 'POST',
//         headers: { 'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content') },
//         url: '/admin/summernote_blobs',
//         cache: false,
//         contentType: false,
//         processData: false,
//         success: function (successData) {
//             if (typeof successData.errors !== 'undefined' && successData.errors !== null) {
//                 return $.each(successData.errors, function (errorKey, messages) {
//                     return $.each(messages, function (messageKey, message) {
//                         return window.alert(message);
//                     });
//                 });
//             }
//             return toSummernote.summernote('pasteHTML', successData.node);
//         }
//     });
// };
//

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
                onInit: function (event) {
                    var attachmentElements = event.editable[0].querySelectorAll('[data-trix-attachment]'),
                        i;
                    for (i = 0; i < attachmentElements.length; i += 1) {
                        new SummernoteAttachment(attachmentElements[i]);
                    }
                }
            }
        });
    });
});
