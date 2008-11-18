# Include hook code here
require 'log'
require 'entry'

config.controller_paths << File.join(directory, 'app', 'controllers')

$LOAD_PATH << File.join(directory, 'app', 'controllers')
$LOAD_PATH << File.join(directory, 'app', 'helpers')

ActiveSupport::Dependencies.load_paths << File.join(directory, 'app', 'controllers')
ActiveSupport::Dependencies.load_paths << File.join(directory, 'app', 'helpers')