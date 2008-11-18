require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

describe "TailLog::Entry" do
  before(@each) do
    @init_array                            = [1, 'MyController#action', '121.1.1.99', '2008-11-16', '09:46:33', 'GET']
    @start_index, @page, @ip, @date, @time = @init_array
    @entry                                 = TailLog::Entry.new(@start_index, @page, @ip, @date, @time, @method)
    @entry.finish_index                    = 100
  end
  
  it "should set the processing line fields on initialization" do
    [:start_index, :page, :ip, :date, :time, :method].each do |field|
      @entry.send(field).should == instance_variable_get("@#{field}".to_sym)
    end
  end
  
  it "should be incomplete if there's no finish line" do
    @entry.incomplete?.should be_false
    @entry.finish_index = nil
    @entry.incomplete?.should be_true
  end
  
  describe ".completed_line" do
    it "should set completed_index to the most recent line in the logfile" do
      @entry.complete_line 100, []
      @entry.completed_index.should == 99
    end
  end

  describe ".params_line" do
    it "should set params_index to the most recent line in the logfile" do
      @entry.params_line 100, []
      @entry.params_index.should == 99
    end
  end
end