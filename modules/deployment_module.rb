class DeploymentModule
  def self.call(ctx)

    ctx.gem_group :development do
      gem 'capistrano-rvm',       require: false
      gem 'capistrano-passenger', require: false
      gem 'capistrano-rails',     require: false
      gem 'capistrano-sidekiq',   require: false
    end

  end
end
