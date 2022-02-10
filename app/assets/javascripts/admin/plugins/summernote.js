/* eslint no-alert: 'off' */
/*global $, FormData */
// window.b2bylon.summernote.sendFile = function (file, toSummernote) {
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
// window.b2bylon.summernote.addConfig('pico', {
//     toolbar: [
//         ['style', ['bold', 'italic']],
//         ['font', ['superscript', 'subscript']],
//         ['code', ['codeview']]
//     ]
// });
//
// window.b2bylon.summernote.addConfig('newsletters', {
//     toolbar: [
//         ['style', ['bold', 'italic']],
//         ['link', ['linkDialogShow', 'unlink']],
//         ['code', ['codeview']]
//     ]
// });
//
// window.b2bylon.summernote.addConfig('nano', {
//     toolbar: [
//         ['style', ['bold', 'italic']],
//         ['font', ['superscript', 'subscript']],
//         ['alignment', ['ul']],
//         ['code', ['codeview']]
//     ]
// });
//
// window.b2bylon.summernote.addConfig('mini', {
//     toolbar: [
//         ['headline', ['style']],
//         ['style', ['bold', 'italic']],
//         ['font', ['superscript', 'subscript']],
//         ['alignment', ['ul', 'ol', 'paragraph']],
//         ['insert', ['hr']],
//         ['link', ['linkDialogShow', 'unlink']],
//         ['code', ['codeview']]
//     ],
//     styleTags: ['p', 'blockquote', 'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6']
// });
//
// window.b2bylon.summernote.addConfig('full', {
//     disableDragAndDrop: false,
//     toolbar: [
//         ['headline', ['style']],
//         ['style', ['bold', 'italic']],
//         ['font', ['superscript', 'subscript']],
//         ['alignment', ['ul', 'ol', 'paragraph']],
//         ['insert', ['hr']],
//         ['link', ['linkDialogShow', 'unlink']],
//         ['media', ['picture']],
//         ['code', ['codeview']]
//     ],
//     popover: {
//         image: [
//             ['remove', ['removeMedia']]
//         ]
//     }
// }, 'mini');
//
// window.b2bylon.summernote.configs.full.callbacks.onImageUpload = function (files) {
//     'use strict';
//     window.b2bylon.summernote.sendFile(files[0], $(this));
// };
//
// $.extend($.summernote.lang['en-US'].image, {
//     dragImageHere: 'Drag file here',
//     dropImage: 'Drop file'
// });

$(function () {
    'use strict';

    $('[data-provider="summernote"]').each(function () {
        $(this).summernote({
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic', 'clear']],
                ['para', ['ul', 'ol']],
                ['table', ['table']],
                ['insert', ['link', 'picture', 'video']],
                ['view', ['codeview', 'help']]
            ],
            styleTags: [
                'p',
                { title: 'Blockquote', tag: 'blockquote', className: 'blockquote', value: 'blockquote' },
                'pre',
                'h2',
                'h3',
                'h4'
            ]
        });
    });
});
