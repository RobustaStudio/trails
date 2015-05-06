::TEMPLATE_PATH = File.dirname(__FILE__)
require_relative 'config'
require_relative 'snippets'
Dir["#{TEMPLATE_PATH}/modules/**/*.rb"].sort.each { |f| require f }

def execute_modules(hook)
  MODULES[hook].each do |module_name|
    klass = eval "#{module_name}Module"
    klass.call self
  end
end

execute_modules 'before_bundle'
after_bundle { execute_modules 'after_bundle' }
