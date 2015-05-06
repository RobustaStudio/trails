require 'yaml'
TARGET = 'bin/trails.rb'

CONFIGS = Dir['config/**/*.yml'].sort.map do |f|
  const = File.basename(f, '.*').upcase.to_sym
  "#{const} = #{YAML.load_file(f)}"
end.join "\n"

SNIPPETS = {}
Dir['snippets/**/*'].sort.each do |f|
  sym = File.basename(f, '.*').to_sym
  SNIPPETS[sym] = File.readlines(f).join
end

MODULES = Dir['modules/**/*.rb'].sort.map do |f|
  File.read(f)
end.join "\n"

OUTPUT = <<-EOT
#{CONFIGS}
SNIPPETS = #{SNIPPETS}
#{MODULES}

def execute_modules(hook)
  MODULES[hook].each do |module_name|
    klass = eval "\#{module_name}Module"
    klass.call self
  end
end

execute_modules 'before_bundle'
after_bundle { execute_modules 'after_bundle' }
EOT

File.write(TARGET, OUTPUT)
puts "TRails compiled successfully. #{TARGET}"
