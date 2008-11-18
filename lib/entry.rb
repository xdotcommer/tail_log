class TailLog::Entry
  attr_accessor :start_index, :page, :ip, :date, :time, :method
  attr_accessor :duration, :reqs, :rend_time, :rend_percent, :db_time, :db_percent, :status, :url
  attr_accessor :finish_index, :log, :params, :params_index, :completed_index
  
  def incomplete?
    @finish_index.nil? 
  end

  def initialize(start_index, page, ip, date, time, method)
    @start_index, @page, @ip, @date, @time, @method = start_index, page, ip, date, time, method
  end
  
  def params_line(length, params)
    @params_index = length - 1
    @params       = params
  end

  def complete_line(length, args)
    ["@duration", "@reqs", "@rend_time", "@rend_percent", "@db_time", "@db_percent", "@status", "@url"].zip(args).each do |method_and_value|
      instance_variable_set(method_and_value[0].to_sym, method_and_value[1])
    end
    @completed_index = length - 1
  end
end
