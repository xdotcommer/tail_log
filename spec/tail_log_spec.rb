require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

LOGFILE = <<-EOF
Rendering log_jammer/index
Completed in 0.04880 (20 reqs/sec) | Rendering: 0.00788 (16%) | DB: 0.02741 (56%) | 200 OK [http://localhost/log_jammer?tail=200&logfile=%2FUsers%2Fmcowden%2FDevelopment%2Frails%2Fmigraine%2Flog%2Fproduction.log&commit=SUBMIT&refresh=]


Processing LogJammerController#index (for 127.0.0.1 at 2008-11-15 11:30:00) [GET]
  Session ID: BAh7CDoJdXNlcm86CVVzZXIZOhVAbGF0ZXN0X21pZ3JhaW5lMDoWQGhlYWx0
aHlfam91cm5hbHMwOg5AYXJ0aWNsZXMwOhBAZmF2b3JhYmxlczA6D0BmYXZv
MDoRcmVkaXJlY3RfdXJpMCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6
Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA==--51ae2b3cd51519de46091e8f69c1f0f7414960e1
  Parameters: {"logfile"=>"/Users/mcowden/Development/rails/migraine/log/production.log", "commit"=>"SUBMIT", "action"=>"index", "refresh"=>"", "tail"=>"200", "controller"=>"log_jammer"}
Rendering log_jammer/index
Completed in 0.04880 (20 reqs/sec) | Rendering: 0.00788 (16%) | DB: 0.02741 (56%) | 200 OK [http://localhost/log_jammer?tail=200&logfile=%2FUsers%2Fmcowden%2FDevelopment%2Frails%2Fmigraine%2Flog%2Fproduction.log&commit=SUBMIT&refresh=]


Processing LogJammerController#index (for 127.0.0.1 at 2008-11-15 14:06:47) [GET]
  Session ID: BAh7CDoJdXNlcm86CVVzZXIZOhVAbGF0ZXN0X21pZ3JhaW5lMDoQQGZhdm9y
YWJsZXMwOg5AYXJ0aWNsZXMwOhZAaGVhbHRoeV9qb3VybmFsczA6D0BmYXZv
MDoRcmVkaXJlY3RfdXJpMCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6
Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA==--e9ee7e34c745936b11b735bc73e874715a09d4cb
  Parameters: {"logfile"=>"/Users/mcowden/Development/rails/migraine/log/production.log", "commit"=>"SUBMIT", "action"=>"index", "refresh"=>"", "tail"=>"200", "controller"=>"log_jammer"}
Rendering log_jammer/index
Completed in 0.05227 (19 reqs/sec) | Rendering: 0.00259 (4%) | DB: 0.03326 (63%) | 200 OK [http://localhost/log_jammer?tail=200&logfile=%2FUsers%2Fmcowden%2FDevelopment%2Frails%2Fmigraine%2Flog%2Fproduction.log&commit=SUBMIT&refresh=]


Processing LogJammerController#index (for 127.0.0.1 at 2008-11-15 14:06:47) [GET]
  Session ID: BAh7CDoJdXNlcm86CVVzZXIZOhVAbGF0ZXN0X21pZ3JhaW5lMDoQQGZhdm9y
YWJsZXMwOg5AYXJ0aWNsZXMwOhZAaGVhbHRoeV9qb3VybmFsczA6D0BmYXZv
MDoRcmVkaXJlY3RfdXJpMCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6
EOF


describe "TailLog::Log" do
  before(:each) do
    @logfile  = mock_logfile
    @mock_log = mock(TailLog::Log)

    @tail     = 500
    @filename = "production.log"
    @options  = {:tail => @tail}
    @log      = TailLog::Log.new(@filename, @options)
  end
  
  describe "#new" do
    it "should set the log file, tail length, & initialize arrays" do
      @log.filename.should == @filename
      @log.tail.should == @tail
      @log.logfile.should == []
      @log.entries.should == []
    end
  end
  
  describe "#tail" do
    it "should call process_file on a new TailLog::Log" do
      @mock_log.should_receive(:process_file).and_return nil
      TailLog::Log.should_receive(:new).with(@filename, @options).and_return @mock_log
      TailLog::Log.tail(@filename, @tail)
    end
  end
  
  describe ".process_file" do
    before(:each) do
      @log.process_file
    end
    
    it "should read the logfile into @logfile" do
      @log.logfile.should == @logfile
    end
    
    it "should create 2 entries" do
      @log.entries.length.should == 2
    end
    
    it "should set the start index to the 'Processing' line" do
      @logfile[@log.entries.first.start_index].should =~ /Processing/
      @logfile[@log.entries.last.start_index].should =~ /Processing/
    end
    
    it "should set the params index to the 'Parameters' line" do
      @logfile[@log.entries.first.params_index].should =~ /Parameters/
      @logfile[@log.entries.last.params_index].should =~ /Parameters/
    end
    
    it "should set the completed index to the 'Completed' line" do
      @logfile[@log.entries.first.completed_index].should =~ /Completed in/
      @logfile[@log.entries.last.completed_index].should =~ /Completed in/
    end
    
    it "should begin the entries with the first processing line" do
      @log.entries.first.start_index.should == 4
    end

    it "should ignore any incomplete lines when creating entries" do
      @log.entries.last.finish_index.should == 23
    end
    
    
    it "should set the proper values for the entries" do
      entry = @log.entries.first
      entry.page.should         == 'LogJammerController#index'
      entry.ip.should           == '127.0.0.1'
      entry.date.should         == '2008-11-15'
      entry.time.should         == '11:30:00'
      entry.method.should       == 'GET'
      entry.duration.should     == '0.04880'
      entry.reqs.should         == '20'
      entry.rend_time.should    == '0.00788'
      entry.rend_percent.should == '16'
      entry.db_time.should      == '0.02741'
      entry.db_percent.should   == '56'
      entry.status.should       == '200 OK'
      entry.url.should          == 'http://localhost/log_jammer?tail=200&logfile=%2FUsers%2Fmcowden%2FDevelopment%2Frails%2Fmigraine%2Flog%2Fproduction.log&commit=SUBMIT&refresh='
    end
  end
  
  describe ".details_for" do
    before(:each) do
      @log.process_file
    end
        
    it "should include all lines for the entry" do
      details = @log.details_for(@log.entries.first)
      details.first.should =~ /Processing/
      details[details.length - 3].should =~ /Completed in/ # Two empty lines after the Completed in line
    end
  end
  
  describe ".brief_for" do
    before(:each) do
      @log.process_file
    end
        
    it "should skip processing through parameter lines and the completed line" do
      @log.brief_for(@log.entries.first).each do |line| 
        line.should_not =~ /Processing/
        line.should_not =~ /Parameters:/
        line.should_not =~ /Session ID:/
        line.should_not =~ /Completed in/
      end
    end
  end
  
  def mock_logfile
    returning(LOGFILE.split("\n").map { |e| e + "\n" }) do |logfile|
      tail_file = File::Tail::Logfile.stub!(:tail)
      logfile.each {|line| tail_file.and_yield(line) }
    end
  end
end