BRANCHES = ["production", "staging"]
DIRECTORIES = ["app/exceptions", "app/validators", "app/services"]
MODULES = ["View", "Assets", "Gitignore", "Env", "Dir", "Test", "Gems", "Deployment", "Devise", "Uncomment", "Branch"]
UNCOMMENT = ["Gemfile", "config/routes.rb"]
SNIPPETS = {:application_coffee=>"#= require jquery\n#= require jquery_ujs\n", :application_haml=>"!!!\n%html\n  %head\n    %title \"HAML'd\"\n    = stylesheet_link_tag    \"application\"\n    = javascript_include_tag \"application\"\n    = csrf_meta_tags\n  %body\n    = yield\n", :database_cleaner=>"require 'database_cleaner'\nRSpec.configure do |config|\n  config.before(:suite) do\n    DatabaseCleaner.strategy = :transaction\n    DatabaseCleaner.clean_with(:truncation)\n  end\n\n  config.around(:each) do |example|\n    DatabaseCleaner.cleaning do\n      example.run\n    end\n  end\nend\n", :development_prepend=>"# Stop sending emails check log for email body\nconfig.action_mailer.perform_deliveries = false\n", :factory_girl=>"require 'factory_girl'\nRSpec.configure do |config|\n  config.include FactoryGirl::Syntax::Methods\nend\n", :gitignore=>"/.bundle\n/.ruby-gemset\n/.ruby-version\n/.rvmrc\n/config/database.yml\n/config/mail.yml\n/config/secrets.yml\n/config/twilio.yml\n/config/aws.yml\n/log/*.log\n/public/assets\n/public/system\n/tmp\n/.idea\n/.capistrano\n/coverage\ndump.rdb\n", :spec_helper_prepend=>"require 'simplecov'\nDir['./spec/support/**/*.rb'].sort.each { |f| require f }\nSimpleCov.start 'rails'\n"}
class AssetsModule
  def self.call(ctx)
    ctx.remove_file 'app/assets/javascripts/application.js'
    ctx.create_file 'app/assets/javascripts/application.coffee', SNIPPETS[:application_coffee]
  end
end

class BranchModule
  def self.call(ctx)
    ctx.after_bundle do
      ctx.git :init
      ctx.git add: '.'
      ctx.git commit: "-m 'Initial commit'"
      BRANCHES.each { |name| ctx.git branch: name }
    end
  end
end

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

class DeviseModule
  def self.call(ctx)
    return unless ctx.yes? 'Should we add devise for you? (Yn) : '
    ctx.gem 'devise'

    ctx.after_bundle do
      ctx.generate 'devise:install'
      model = ctx.ask 'What is the name for Devise model? :'
      ctx.generate 'devise', model
    end

  end
end

class DirModule
  def self.call(ctx)

    DIRECTORIES.each do |directory|
      FileUtils.mkdir_p directory
      ctx.inside directory do
        ctx.run 'touch .keep'
      end
    end

  end
end

class EnvModule
  def self.call(ctx)
    FileUtils.cp 'config/environments/production.rb', 'config/environments/staging.rb'
    ctx.environment SNIPPETS[:development_prepend], env: 'development'
  end
end

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

class GitignoreModule
  def self.call(ctx)
    ctx.create_file '.gitignore', SNIPPETS[:gitignore]
  end
end

class TestModule
  def self.call(ctx)
    ctx.gem_group :development, :staging, :test do
      ctx.gem 'rspec-rails'
      ctx.gem 'rspec_junit_formatter'
      ctx.gem 'rspec-collection_matchers'
      ctx.gem 'factory_girl_rails'
      ctx.gem 'faker'
      ctx.gem 'database_cleaner'
      ctx.gem 'simplecov', require: false
    end

    ctx.after_bundle do
      ctx.generate 'rspec:install'
      ctx.run 'echo "--format documentation" >> .rspec'
      ctx.prepend_to_file 'spec/spec_helper.rb', SNIPPETS[:spec_helper_prepend]
      ctx.create_file 'spec/support/factory_girl.rb', SNIPPETS[:factory_girl]
      ctx.create_file 'spec/support/database_cleaner.rb', SNIPPETS[:database_cleaner]
    end

  end
end

class UncommentModule
  def self.call(ctx)
    UNCOMMENT.each do |file|
      ctx.gsub_file file, /^\s*#.*$\n/, ''
    end
  end
end

class ViewModule
  def self.call(ctx)
    ctx.gem 'haml-rails'
    ctx.remove_file 'app/views/layouts/application.html.erb'
    ctx.create_file 'app/views/layouts/application.html.haml', SNIPPETS[:application_haml]
  end
end


MODULES.each do |module_name|
  klass = eval "#{module_name}Module"
  klass.call self
end
