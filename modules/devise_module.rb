class DeviseModule
  def self.call(ctx)
    return unless ctx.yes? 'Should we add devise for you?'
    ctx.gem 'devise'
    ctx.generate 'devise:install'

    model = ctx.ask 'What is the name for Devise ? :'
    ctx.generate 'devise', model
  end
end
