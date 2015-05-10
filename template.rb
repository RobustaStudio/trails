::TEMPLATE_PATH = File.dirname(__FILE__)
require_relative 'config'
require_relative 'snippets'
Dir["#{TEMPLATE_PATH}/modules/**/*.rb"].sort.each { |f| require f }

MODULES.each do |module_name|
  klass = eval "#{module_name}Module"
  klass.call self
end
