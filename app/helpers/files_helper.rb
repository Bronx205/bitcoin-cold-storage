module FilesHelper

	def save_file(path, data)
		File.open(path,'w') {|file| file.write data }
	end

	def delete_file(path)
		File.delete(path) if File.exist?(path)
	end	

	def relative_root_path
		File.expand_path(Rails.root)
	end

	def file_there?(path)
		File.exist?(path)
	end
			
end