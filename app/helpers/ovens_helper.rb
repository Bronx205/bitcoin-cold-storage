module OvensHelper

	include ColdStorageHelper

	def file_there?(path=encrypted_file_path)
		File.exist?(path)
	end

	def load_encrypted(path=encrypted_file_path)		
		File.read(path) if file_there?(path)
	end

	def decrypt_loaded(path=encrypted_file_path,password)
		decrypt_my_file(load_encrypted(path),password)
	end



end
