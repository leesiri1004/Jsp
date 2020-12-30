/**
 * 동의체크 여부 확인 
 */
    	$(function () {
			
    		var chk1 = $('input[name=chk1]');
    		var chk2 = $('input[name=chk2]');
    		
    		$('.next').click(function () {
				
    			var isChecked1 = chk1.is(':checked');
    			var isChecked2 = chk2.is(':checked');
    			
    			if (isChecked1 && isChecked2) { // chk1이 체크되고 chk2가 체크되었으면
					return true;
				} else {
					alert('동의체크를 하십시요.');
	    			return false;
				}
    			
			});
    		
		});