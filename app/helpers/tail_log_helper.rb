module TailLogHelper
  def tail_log_format_float(value)
  	sprintf('%.3f', value) if value
  end

  def tail_log_stats(entry)
  	"Rendering (#{entry.rend_percent}%): #{tail_log_format_float(entry.rend_time)}  Database (#{entry.db_percent}%): #{tail_log_format_float(entry.db_time)}"
  end

  def tail_log_refresh_class
   	@refresh ? 'tail_log_refresh_on' : 'tail_log_refresh_off' 
  end
end