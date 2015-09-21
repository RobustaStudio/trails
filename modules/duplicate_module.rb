class DuplicateModule
  def self.call(ctx)
    DUPLICATES.each do |file|
      FileUtils.cp file, file.split('.').first + '.example' + File.extname(file)
      ctx.append_to_file '.gitignore', "/#{file}\n"
    end
  end
end
