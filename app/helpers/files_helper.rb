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

	def coldstorage_directory
		relative_root_path +  '/files/'
	end

	def plaintext_file_name
		'plaintext.html'
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def no_file_message
		'Decryption failed because the file '+ encrypted_file_name + ' was not found'
	end

	def plaintext_file_path
		coldstorage_directory+plaintext_file_name
	end

	def encrypted_file_path
		coldstorage_directory+encrypted_file_name
	end	
			
end