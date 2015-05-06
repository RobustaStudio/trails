class BranchModule
  def self.call(ctx)
    ctx.git :init
    ctx.git add: '.'
    ctx.git commit: "-m 'Initial commit'"
    BRANCHES.each { |name| ctx.git branch: name }
  end
end
