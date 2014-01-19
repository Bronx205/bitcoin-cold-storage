module CryptoHelper

	def encrypt_my_file(file,password)
		AESCrypt.encrypt(file,password)
	end

	def decrypt_my_file(file,password)
		AESCrypt.decrypt(file,password)
	end	

end