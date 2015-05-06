SNIPPETS = {}
Dir["#{TEMPLATE_PATH}/snippets/**/*"].sort.each do |f|
  sym = File.basename(f, '.*').to_sym
  SNIPPETS[sym] = File.readlines(f).join
end
