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
                },
                // Remove text styles on paste
                onPaste: function (event) {
                    var paragraph;
                    event.preventDefault();
                    // Get and trim clipboard content as paragraph
                    paragraph = document.createElement('p');
                    paragraph.textContent = ((event.originalEvent || event).clipboardData || window.clipboardData).getData('Text').trim();
                    // Delete selection if anything is selected (expected behaviour on paste)
                    if ((window.getSelection !== undefined ? window.getSelection() : document.selection.createRange()).toString().length > 0) {
                        document.execCommand('delete', false);
                    }
                    // Insert trimmed clipboard content as paragraph
                    document.execCommand('insertHTML', false, paragraph.outerHTML);
                }
            }
        });
    });
});
