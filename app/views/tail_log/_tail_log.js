var TailLog = {
	toggleDetails: function(index) {
		this.swapClass('tail_log_toggle_' + index, 'tail_log_toggle_plus', 'tail_log_toggle_minus');
		$$('.tail_log_entry_' + index).invoke('toggle');
	},
	
	toggleRefresh: function() {
		if ($('tail_log_toggle_refresh').hasClassName('tail_log_refresh_on'))
		{
			$('refresh').value = null;
		}
		else
		{
			$('refresh').value = 1;
		}
		this.swapClass('tail_log_toggle_refresh', 'tail_log_refresh_on', 'tail_log_refresh_off');
		$('tail_log_form').submit();
	},
	
	swapClass: function(id, class1, class2) {
		if ($(id).hasClassName(class1))
		{
			$(id).removeClassName(class1);
			$(id).addClassName(class2);
		}
		else
		{
			$(id).removeClassName(class2);
			$(id).addClassName(class1);
		}
	},
}
