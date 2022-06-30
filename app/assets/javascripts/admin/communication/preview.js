$(function() {
  'use strict';
  var modes = ['mobile', 'tablet', 'desktop'],
      mode = '';
  $('.preview__button').on('click', function(){
    mode = $(this).data('mode');
    $('.preview__button').removeClass('btn-primary').addClass('btn-light');
    $(this).removeClass('btn-light').addClass('btn-primary');
    $('#preview').removeClass('preview--desktop').removeClass('preview--tablet').removeClass('preview--mobile').addClass('preview--' + mode);
  });
});