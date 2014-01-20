class Quartermaster
	include FilesHelper
	require 'bitcoin'

	def initialize(private_key_array=[])
		# raise 'Empty Key Array' if private_key_array.blank?	
		# raise 'Invalid keys' unless valid_array?(private_key_array)
	end

	def save_full_html(plain_file,encrypted_file)
		save_file(plaintext_file_path,plain_file)
		save_file(encrypted_file_path,encrypted_file)
	end	

	private
		def valid_array?(private_key_array)
			private_key_array.each do |key|
				return false if valid_private_key?(key)
			end
			return true
		end

		def valid_private_key?(key)
			Bitcoin::valid_address?(Bitcoin::Key.from_base58(key.to_base58).addr)
		end
end