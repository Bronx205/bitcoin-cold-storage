module StorageHelper

	def save_coldstorage_files(plain_file,encrypted_file)
		save_file(plaintext_file_path,plain_file)
		save_file(encrypted_file_path,encrypted_file)
	end	

end