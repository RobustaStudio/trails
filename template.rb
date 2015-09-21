::TEMPLATE_PATH = File.dirname(__FILE__)
require_relative 'config'
require_relative 'snippets'
Dir["#{TEMPLATE_PATH}/modules/**/*.rb"].sort.each { |f| require f }

@env = ask("What is type of the project? web/api : ").downcase
@env = "web" unless (["web", "api"]).include? @env

# add env propety to context instance
def self.env
  @env
end

MODULES[self.env].each do |module_name|
  klass = eval "#{module_name}Module"
  klass.call self
end
