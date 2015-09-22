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
