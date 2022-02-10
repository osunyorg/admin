/* eslint no-alert: 'off' */
/*global $, FormData */
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

//



$(function () {
    'use strict';

    $.extend($.summernote.lang['en-US'].image, {
        dragImageHere: 'Drag file here',
        dropImage: 'Drop file'
    });

    $('[data-provider="summernote"]').each(function () {
        $(this).summernote({
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
                    var blob = uploadFile(files[0]);
                    console.log(blob);
                //     'use strict';
                //     window.osuny.summernote.sendFile(files[0], $(this));
                }
            }
        });
    });
});
