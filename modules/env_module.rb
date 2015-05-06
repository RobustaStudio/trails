class EnvModule
  def self.call(ctx)
    FileUtils.cp 'config/environments/production.rb', 'config/environments/staging.rb'
    ctx.environment SNIPPETS[:development_prepend], env: 'development'
  end
end
