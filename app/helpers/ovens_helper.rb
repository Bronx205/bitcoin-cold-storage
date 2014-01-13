module OvensHelper
	include FreezersHelper

	def load_encrypted(path=encrypted_file_path)		
		File.read(path) if File.exist?(path)
	end


end
