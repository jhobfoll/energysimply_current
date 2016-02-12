$(document).ready(function() {
	
	$('#SubmitBillHere').hide()
	$('#SubmitBillBelow').hide()
	
	$("input[name='user[bill_send_method]']").change(function() {
		
		if ($("input[name='user[bill_send_method]']:checked").val() == 'submit'){
	      	$('#SubmitBillHere').show()
	      	$('#SubmitBillBelow').show()
		 }
		 else{
		      $('#SubmitBillHere').hide()
		      $('#SubmitBillBelow').hide()
		 }	 
	});

	$('#fillBillHere').hide()
	$('#FillBillBelow').hide()
	
	$("input[name='user[bill_send_method]']").change(function() {
		
		if ($("input[name='user[bill_send_method]']:checked").val() == 'manual_enter'){
	      	$('#fillBillHere').show()
	      	$('#FillBillBelow').show()
		 }
		 else{
		      $('#fillBillHere').hide()
		      $('#FillBillBelow').hide()
		 }	 
	});

});	