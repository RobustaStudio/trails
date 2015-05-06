class ViewModule
  def self.call(ctx)
    ctx.gem 'haml-rails'
    ctx.remove_file 'app/views/layouts/application.html.erb'
    ctx.create_file 'app/views/layouts/application.html.haml', SNIPPETS[:application_haml]
  end
end
