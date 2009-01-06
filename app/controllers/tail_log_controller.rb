require 'null_logger'

class TailLogController < ApplicationController
  layout nil
  skip_filter filter_chain
  filter_parameter_logging :password, :login # need to use POST not GET...
  around_filter :no_log
  
  def index
    if params[:login] == TailLog.login && params[:password] == TailLog.password
      @logfiles = Dir.glob("#{RAILS_ROOT}/log/*.log")
      @tail     = params[:tail] ? params[:tail].to_i : 200
      @refresh  = ! params[:refresh].blank?
      @login    = params[:login]
      @password = params[:password]
      @current  = params[:logfile] || default_logfile(@logfiles) || @logfiles.first
      @log      = TailLog::Log.new(@current, {:tail => @tail})
      @log.process_file
    else
      redirect_to(:action => :login)
    end
  end
  
  def logger(*args)
    NullLogger.new
  end

private
  def default_logfile(logfiles)
    logfiles.detect {|d| d =~ /\/production\.log$/}
  end

  def no_log
    RAILS_DEFAULT_LOGGER.silence do
      yield
    end
  end
end

TailLogController.view_paths = File.join(File.dirname(__FILE__), '..', 'views')