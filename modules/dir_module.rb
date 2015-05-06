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
