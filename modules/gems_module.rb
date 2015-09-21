class GemsModule
  def self.call(ctx)
    ctx.gem_group :development, :staging, :test do
      gem 'pry'
    end

    ctx.gem_group :development do
      ctx.gem 'quiet_assets'
      ctx.gem 'annotate'
    end

    # set mysql2 version explicity
    # see: http://stackoverflow.com/questions/22932282/gemloaderror-specified-mysql2-for-database-adapter-but-the-gem-is-not-loade
    ctx.gsub_file "Gemfile", /^gem\s+["']mysql2["'].*$/,"gem 'mysql2', '~> 0.3.18'"
  end
end
