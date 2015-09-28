class TestModule
  def self.call(ctx)
    ctx.gem_group :development, :staging, :test do
      ctx.gem 'factory_girl_rails'
      ctx.gem 'faker'
      ctx.gem 'database_cleaner'
      ctx.gem 'simplecov', require: false
    end

    ctx.gem_group :development, :test do
      ctx.gem 'rspec-rails'
      ctx.gem 'rspec-collection_matchers'
    end

    ctx.gem_group :test do
      ctx.gem 'rspec_junit_formatter'
    end

    ctx.after_bundle do
      ctx.run 'spring stop' # see: https://github.com/rspec/rspec-rails/issues/996
      ctx.generate 'rspec:install'
      ctx.run 'echo "--format documentation" >> .rspec'
      ctx.prepend_to_file 'spec/spec_helper.rb', SNIPPETS[:spec_helper_prepend]
      ctx.create_file 'spec/support/factory_girl.rb', SNIPPETS[:factory_girl]
      ctx.create_file 'spec/support/database_cleaner.rb', SNIPPETS[:database_cleaner]
    end
  end
end
