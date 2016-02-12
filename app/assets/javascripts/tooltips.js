$(document).ready(function () {
  $("span.question").hover(function () {
    tip = $(this).children('div.tooltip').get(0);
    $(tip).css("display", "block")
  }, function() {
    $(tip).css("display", "none")
  });
});
