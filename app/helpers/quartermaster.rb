class Quartermaster
	include FilesHelper
	
	def save_full_html(plain_file,encrypted_file)
		save_file(plaintext_file_path,plain_file)
		save_file(encrypted_file_path,encrypted_file)
	end	

end