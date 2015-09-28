BRANCHES = ["production", "staging"]
DIRECTORIES = ["app/exceptions", "app/validators", "app/services"]
DUPLICATES = ["config/database.yml", "config/secrets.yml"]
MODULES = {"web"=>["View", "Assets", "Gitignore", "Env", "Dir", "Test", "Gems", "Deployment", "Devise", "Uncomment", "Branch", "Duplicate", "Hook", "Readme"], "api"=>["View", "Assets", "Gitignore", "Env", "Dir", "Test", "Gems", "Deployment", "Devise", "Uncomment", "Branch", "Duplicate", "Hook", "Readme"]}
UNCOMMENT = ["Gemfile", "config/routes.rb"]
SNIPPETS = {:README=>"## README\n\nThis README would normally document whatever steps are necessary to get the\napplication up and running.\n\nThings you may want to cover:\n\n*   Ruby version\n\n*   System dependencies\n\n*   Configuration\n\n*   Database creation\n\n*   Database initialization\n\n*   How to run the test suite\n\n*   Services (job queues, cache servers, search engines, etc.)\n\n*   Deployment instructions\n\n*   ...\n\n\nPlease feel free to use a different markup language if you do not plan to run\n`rake doc:app`.\n", :application_coffee=>"#= require jquery\n#= require jquery_ujs\n", :application_haml=>"!!!\n%html\n  %head\n    %title HAML'd\n    = stylesheet_link_tag    \"application\"\n    = javascript_include_tag \"application\"\n    = csrf_meta_tags\n  %body\n    = yield\n", :application_scss=>"", :database_cleaner=>"require 'database_cleaner'\nRSpec.configure do |config|\n  config.before(:suite) do\n    DatabaseCleaner.strategy = :transaction\n    DatabaseCleaner.clean_with(:truncation)\n  end\n\n  config.around(:each) do |example|\n    DatabaseCleaner.cleaning do\n      example.run\n    end\n  end\nend\n", :development_prepend=>"# Stop sending emails check log for email body\nconfig.action_mailer.perform_deliveries = false\n", :factory_girl=>"require 'factory_girl'\nRSpec.configure do |config|\n  config.include FactoryGirl::Syntax::Methods\nend\n", :gitignore=>"/.bundle\n/.ruby-gemset\n/.ruby-version\n/.rvmrc\n/config/mail.yml\n/config/twilio.yml\n/config/aws.yml\n/log/*.log\n/public/assets\n/public/system\n/public/uploads\n/tmp\n/.idea\n/.capistrano\n/coverage\ndump.rdb\n", :spec_helper_prepend=>"require 'simplecov'\nDir['./spec/support/**/*.rb'].sort.each { |f| require f }\nSimpleCov.start 'rails'\n"}
class AssetsModule
  def self.call(ctx)
    # js to coffee
    ctx.remove_file 'app/assets/javascripts/application.js'
    ctx.create_file 'app/assets/javascripts/application.coffee', SNIPPETS[:application_coffee]
    # css to sass
    ctx.remove_file 'app/assets/stylesheets/application.css'
    ctx.create_file 'app/assets/stylesheets/application.scss', SNIPPETS[:application_scss]
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

    ctx.after_bundle do
      ctx.run 'cap install'
    end

  end
end

class DeviseModule
  def self.call(ctx)
    if ctx.yes?('Should we add devise for you? [Y/n] : ')
      ctx.gem 'devise'

      ctx.after_bundle do
        ctx.generate 'devise:install'
        model = ctx.ask 'What is the name for Devise model? :'
        ctx.generate 'devise', model
      end
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

class DuplicateModule
  def self.call(ctx)
    DUPLICATES.each do |file|
      FileUtils.cp file, file.split('.').first + '.example' + File.extname(file)
      ctx.append_to_file '.gitignore', "/#{file}\n"
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
    if ctx.env == 'web' # gems thar only blong to project of type "web"
      ctx.gem 'kaminari'
    elsif ctx.env == 'api' # gems thar only blong to project of type "api"
      ctx.gem 'rabl'
    end

    # shared gems
    ctx.gem_group :development, :staging, :test do
      gem 'pry'
    end

    ctx.gem_group :development do
      ctx.gem 'quiet_assets'
      ctx.gem 'annotate'
    end
    # set mysql2 version explicity
    # see: http://stackoverflow.com/questions/22932282/gemloaderror-specified-mysql2-for-database-adapter-but-the-gem-is-not-loade
    ctx.gsub_file 'Gemfile', /^gem\s+["']mysql2["'].*$/, "gem 'mysql2', '~> 0.3.18'"
  end
end

class GitignoreModule
  def self.call(ctx)
    ctx.create_file '.gitignore', SNIPPETS[:gitignore]
  end
end

class HookModule
  def self.call(ctx)
    ctx.after_bundle do
      ctx.generate 'annotate:install'
    end
  end
end

class ReadmeModule
  def self.call(ctx)
    ctx.remove_file 'README.rdoc'
    ctx.create_file 'README.md', SNIPPETS[:README]
  end
end

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
