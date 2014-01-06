module CryptoHelper
	require 'aes'

	def encrypt_my_page(page,password)
		AES.encrypt(page,password)
	end
end