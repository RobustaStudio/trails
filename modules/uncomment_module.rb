class UncommentModule
  def self.call(ctx)
    UNCOMMENT.each do |file|
      ctx.gsub_file file, /^\s*#.*$\n/, ''
    end
  end
end
