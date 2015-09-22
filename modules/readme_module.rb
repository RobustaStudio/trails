require 'rdoc'
class ReadmeModule
  def self.call(ctx)
    converter = RDoc::Markup::ToMarkdown.new
    puts 'convert Readme.rdoc'
    rdoc = File.read('README.rdoc')
    ctx.create_file 'README.md', converter.convert(rdoc)
    ctx.remove_file 'README.rdoc'
  end
end
