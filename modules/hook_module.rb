class HookModule
  def self.call(ctx)
    ctx.after_bundle do
      ctx.generate 'annotate:install'
    end
  end
end
