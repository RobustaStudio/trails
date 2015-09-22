class HookModule
  def self.call(ctx)
    ctx.run 'rails g annotate:install'
  end
end
