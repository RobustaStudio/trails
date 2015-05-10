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
