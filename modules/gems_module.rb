class GemsModule
  def self.call(ctx)
    ctx.gem_group :development, :staging, :test do
      gem 'pry'
    end

    ctx.gem_group :development do
      ctx.gem 'quiet_assets'
      ctx.gem 'annotate'
    end
  end
end
