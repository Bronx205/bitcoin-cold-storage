module CryptoHelper
	require 'aes'

	def encrypt_my_page(page,password='foobar')
		AES.encrypt(page,password)
	end
end