class TailLogController < ApplicationController
  layout nil
  
  #RESTFUL??
  def index
    if params[:login] == TailLog.login && params[:password] == TailLog.password
      @logfiles = Dir.glob("#{RAILS_ROOT}/log/*.log")
      @tail     = params[:tail] ? params[:tail].to_i : 200
      @refresh  = ! params[:refresh].blank?
      @login    = params[:login]
      @password = params[:password]
      @current  = params[:logfile] || @logfiles.first # production?
      @log      = TailLog::Log.new(@current, {:tail => @tail})
      @log.process_file
    else
      redirect_to(:action => :login)
    end
  end
  
  def login
  end
end

TailLogController.view_paths = File.join(File.dirname(__FILE__), '..', 'views')