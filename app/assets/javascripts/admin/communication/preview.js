$(function() {
    $('.preview__button__mobile').on('click', function(){
      $('.preview__button').removeClass('btn-primary').addClass('btn-light');
      $('.preview__button__mobile').removeClass('btn-light').addClass('btn-primary');
      $('#preview').removeClass('preview--desktop').removeClass('preview--tablet').addClass('preview--mobile');
    });
    $('.preview__button__tablet').on('click', function(){
      $('.preview__button').removeClass('btn-primary').addClass('btn-light');
      $('.preview__button__tablet').removeClass('btn-light').addClass('btn-primary');
      $('#preview').removeClass('preview--mobile').removeClass('preview--desktop').addClass('preview--tablet');
    });
    $('.preview__button__desktop').on('click', function(){
      $('.preview__button').removeClass('btn-primary').addClass('btn-light');
      $('.preview__button__desktop').removeClass('btn-light').addClass('btn-primary');
      $('#preview').removeClass('preview--mobile').removeClass('preview--tablet').addClass('preview--desktop');
    });
  });