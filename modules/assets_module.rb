class AssetsModule
  def self.call(ctx)
    ctx.remove_file 'app/assets/javascripts/application.js'
    ctx.create_file 'app/assets/javascripts/application.coffee', SNIPPETS[:application_coffee]
  end
end
