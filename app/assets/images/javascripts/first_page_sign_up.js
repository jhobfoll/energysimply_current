$(document).ready(function() {

	$('#newLoc').hide();
	$('#existLoc').hide();
	$('#newConst').hide();
	$('#existConst').hide();
	$('#fillBillHere').hide();
	$('#emailBill').hide()

	$('#user_svc_new_old').change(function(){
	    if($(this).val() == 'New Location'){
	      $('#newLoc').show()
	      $('#existLoc').hide()
	    }
	    else{
	      $('#newLoc').hide()
	      $('#existLoc').show()
	    }
	});


	$('#user_home_new_old').change(function(){
	    if($(this).val() == 'New Construction'){
	      $('#newConst').show()
	      $('#existConst').hide()
	    }
	    else{
	      $('#newConst').hide()
	      $('#existConst').show()
	    }
	});

	$('#user_bill_send_method').change(function(){
	    if($(this).val() == 'Input Bill Info Here'){
	      $('#uploadBillNow').hide()
	      $('#emailBill').hide()
	      $('#fillBillHere').show()
	    }
	    else if($(this).val() == 'Upload My Bill Now'){
	      $('#fillBillHere').hide()
	      $('#emailBill').hide()
	      $('#uploadBillNow').show()
	    }
	    else {
		  $('#uploadBillNow').hide()
		  $('#fillBillHere').hide()
		  $('#emailBill').show()
		}
	});
});
