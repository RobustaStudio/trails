class ReadmeModule
  def self.call(ctx)
    ctx.remove_file 'README.rdoc'
    ctx.create_file 'README.md', SNIPPETS[:README]
  end
end
