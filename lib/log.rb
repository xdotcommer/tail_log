require 'file/tail'

module TailLog
  mattr_accessor  :login, :password
  
  class Log
    attr_reader   :logfile
    attr_accessor :entries, :filename, :tail

    def self.tail(file, tail)
      returning(self.new(file, :tail => tail)) do |log|
        log.process_file
      end
    end

    def initialize(file, options = {:tail => 200})
      @logfile  = []
      @entries  = []
      @filename = file
      @tail     = options[:tail]
    end
    
    def process_file
      get_matches = lambda { |matches|  matches.to_a.slice(1..matches.to_a.length - 1)  }

      File::Tail::Logfile.tail(@filename, :backward => @tail, :return_if_eof => true) do |line|
        @logfile << line
        update_entries(line, get_matches)
      end

      @entries.pop if @entries.last && @entries.last.incomplete?
    end

    def list
      @entries.map {|s| "#{s.duration}\t#{s.ip} [#{s.method}]\t#{s.date} #{s.time}\t#{s.status}\t#{s.page}\t#{s.url}" }.join("\n")
    end
    
    def details_for(entry)
      @logfile[entry.start_index..entry.finish_index]
    end

    def brief_for(entry)
      finish = entry.completed_index ? entry.completed_index - 1 : entry.finish_index
      @logfile[entry.params_index+1..finish]
    end
  
  private
    def update_entries(line, get_matches)
      if line =~ /^Processing (\S+) \(for (\S+) at (\S+) (\S+)\) \[(\S+)\]\n/
        new_entry(line, get_matches.call($~))
      elsif @entries.last
        existing_entry(line, get_matches)
      end
    end
    
    def new_entry(line, matches)
      closeout_entry unless @entries.empty?
      @entries << Entry.new(@logfile.length - 1, *matches)
    end
    
    def existing_entry(line, get_matches)
      if line =~ /^\s+Parameters:\s+\{(.*)\}\n$/
        @entries.last.params_line @logfile.length, $1
      elsif line =~  /^Completed in (\S+) \((\S+) reqs\/sec\) \| Rendering: (\S+) \((\d+)\%\) \| DB: (\S+) \((\S+)\%\) \| (.*) \[(.*)\]\n$/
        @entries.last.complete_line @logfile.length, get_matches.call($~)
      elsif line =~ /^Completed in (\S+) \((\S+) reqs\/sec\) \| DB: (\S+) \((\S+)\%\) \| (.*) \[(.*)\]\n$/
        @entries.last.complete_line @logfile.length, [$1, $2, nil, nil, $3, $4, $5, $6]
      end
    end
      
    def closeout_entry
      @entries.last.finish_index = @logfile.length - 2
    end
  end
end