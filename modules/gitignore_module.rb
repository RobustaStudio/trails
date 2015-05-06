class GitignoreModule
  def self.call(ctx)
    ctx.create_file '.gitignore', SNIPPETS[:gitignore]
  end
end
