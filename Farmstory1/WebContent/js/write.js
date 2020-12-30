/**
 *  글 삭제 수정
 */
 
    	$(function() {
			
    		// 원글, 댓글 삭제
    		$('.btnDelete, .cmtDelete').click(function() {
				
				var result = confirm("정말 삭제하시겠습니까?");
				
				if (result) {
					return true;
				} else {
					return false;
				}
				
			});
    		
    		var commentValue = '';
    		
    		// 댓글 수정
    		$('.cmtModify').click(function() {
				
    			var btnCancel   = $(this).next();
    			var btnComplete = $(this).next().next();
    			btnCancel.removeClass('disable');
    			btnComplete.removeClass('disable');
    			$(this).addClass('disable');
    			
    			var textarea = $(this).parent().prev();
    			textarea.attr('readonly', false);
    			textarea.focus();
    			commentValue = textarea.text();
    			
    			return false;
			});
    		
    		// 댓글 수정취소 버튼
    		$('.cmtModifyCancel').click(function() {
				
    			$(this).addClass('disable');
    			$(this).next().addClass('disable');
    			$(this).prev().removeClass('disable');
    			
    			$(this).parent().prev().val(commentValue);
    			$(this).parent().prev().attr('readonly', true);
    			
    			return false;
    			
			});
    		
    		// 댓글 수정완료 버튼
    		$('.cmtModifyComplete').click(function() {
				
    			var thisTag  = $(this);
    			var textarea = $(this).parent().prev();
    			var seq   	 = $(this).attr('data-value');
				var content	 = textarea.val();
				
    			var jsonData = {
    					'seq': seq,
    					'content': content
    			};
    			
    			$.ajax({
    				url: '/Jboard1/proc/modifyComment.jsp',
    				type: 'post',
    				data: jsonData,
    				dataType: 'json',
    				success: function(data) {
						
    					if (data.result == 1) {
							alert('수정 완료');
							textarea.attr('readonly', true);
					
							thisTag.addClass('disable');
							thisTag.prev().addClass('disable');
							thisTag.prev().prev().removeClass('disable');
						} else {
							alert('수정 실패');
						}
    					
					}
    			});
    			
    			return false;
    			
			});
    		
		});
    