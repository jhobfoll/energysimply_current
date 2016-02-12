$(document).ready(function() {
	
	$('#wrong_email').hide();
	$('#thanks_for_email').hide();
	checkRefdEmail();
	
	function checkRefdEmail() {
	    $('button#email_ref').click( function(event){
		  console.log("triggered checkRefdEmail");
		  $.ajax({
			url: "/email_refs/check_email?email=" +
				( $('input#ref_email_email').val() ),
			dataType: 'json',
			success: function(data){
				if (data.message =="EmailFound") {       
					console.log("found");
					$('#wrong_email').show(); 
	
				}
				else { 
					console.log("EmailNotFound");
					$('#wrong_email').hide();
					$('.create-referral-email-button').click();
				}
			},
			error: function(msg){
				console.log("ajax error - died " + msg);
				return false;
			}
		  });
		});
		
		$('input#ref_email_email').focus( function(event){
			$('#wrong_email').hide(); 
			$('#thanks_for_email').hide();
		});
	};
});	