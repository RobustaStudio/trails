class HookModule
  def self.call(ctx)
    ctx.after_bundle do
      ctx.run 'rails g annotate:install'
    end
  end
end
