

$(function(){
  if ($('.pagination').length) {
    $(window).scroll(function(){
      var t = $(this);
      var url = $('.pagination .next_page').attr('href');
      if ( url && t.scrollTop() > $(document).height() - t.height() - 100) {
        console.log(1);
        $('.pagination').text(" Загрузка...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});