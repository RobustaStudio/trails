# load all config file into contants respective to their file names
# upcased, so if you added a file "config/database.yml" you can access it using
# the global constant "DATABASE"
require 'yaml'
Dir["#{TEMPLATE_PATH}/config/**/*.yml"].sort.each do |f|
  const = File.basename(f, '.*').upcase.to_sym
  Kernel.const_set const, YAML.load_file(f)
end
