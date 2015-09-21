class DeviseModule
  def self.call(ctx)
    if ctx.yes?('Should we add devise for you? (yes/no) : ')
      ctx.gem 'devise'

      ctx.after_bundle do
        ctx.generate 'devise:install'
        model = ctx.ask 'What is the name for Devise model? :'
        ctx.generate 'devise', model
      end
    end
  end
end
