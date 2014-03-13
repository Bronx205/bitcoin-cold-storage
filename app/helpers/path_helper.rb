module PathHelper

	def relative_root_path
		File.expand_path(Rails.root)
	end

	def usb_path
		'/media/coldstorage/'
	end

	def coldstorage_directory
		relative_root_path +  '/files/'
	end

	def file_fixtures_directory
		relative_root_path +  '/spec/fixtures/files/'
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def public_directory_path
		coldstorage_directory + 'public/'
	end
			
	def private_directory_path
		coldstorage_directory + 'PRIVATE/'
	end

	def encrypted_directory_path
		private_directory_path + 'encrypted/'
	end

	def unencrypted_directory_path
		private_directory_path + 'NON-ENCRYPTED/'
	end	

	def public_addresses_file_name
		'addresses'
	end
	def private_keys_file_name
		'private_keys'
	end
	def password_share_file_name
		'password_share'
	end

	def public_addresses_file_path(file_type)
		public_directory_path+public_addresses_file_name+$tag+"."+file_type
	end

	def private_keys_file_path(file_type,encrypted = true)
		if encrypted
			return encrypted_directory_path+private_keys_file_name+$tag+"."+file_type+".aes"		
		else
			return unencrypted_directory_path+private_keys_file_name+$tag+"."+file_type
		end		
	end

	def password_shares_path(number)
		raise 'Share number must be positive' unless number > 0
		encrypted_directory_path+password_share_file_name+'_'+number.to_s+$tag+'.csv'
	end
end