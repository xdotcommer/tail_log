require 'rake'

task :default => :test

desc 'Install required plugins: rspec & file_tail'
task :install do
  system('gem install file_tail')
  system('gem install rspec')
end

desc 'Run specs'
task :test do
  system('spec spec/*_spec.rb')
end