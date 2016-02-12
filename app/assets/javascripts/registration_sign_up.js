$(document).ready(function() {

  // Set Current-Page Dot Green
  var pathname = window.location.pathname;
    switch (true) {
      case /users\/sign_up/.test(pathname):
        // $('#progressLineDot1').css('background-color', '#00B050');
        $('#progressLineDot1').addClass("active");
        break;
      case /users\/payment/.test(pathname):
        $('#progressLineLeft').addClass("active");
        $('#progressLineDot1').addClass("active");
        $('#progressLineDot2').addClass("active");
        break;
      case /users\/submit_bill/.test(pathname):
        $('#progressLineLeft').addClass("active");
        $('#progressLineRight').addClass("active");
        $('#progressLineDot1').addClass("active");
        $('#progressLineDot2').addClass("active");
        $('#progressLineDot3').addClass("active");
        break;
      default:
        // no match
        break;
    }
});
