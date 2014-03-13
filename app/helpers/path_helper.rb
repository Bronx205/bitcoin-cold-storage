module PathHelper

	def relative_root_path
		File.expand_path(Rails.root) +'/'
	end

	def usb_path
		'/media/coldstorage/' + Time.now.strftime('%Y-%m-%d_%H-%M/').to_s
	end

	def coldstorage_directory(usb=false)
		if usb
			return usb_path
		else
			return relative_root_path +  'files/' 				
		end		
	end

	def file_fixtures_directory
		relative_root_path +  'spec/fixtures/files/'
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def public_directory_path(usb=false)
		coldstorage_directory(usb) + 'public/'
	end
			
	def private_directory_path(usb=false)
		coldstorage_directory(usb) + 'PRIVATE/'
	end

	def encrypted_directory_path(usb=false)
		private_directory_path(usb) + 'encrypted/'
	end

	def unencrypted_directory_path(usb=false)
		private_directory_path(usb) + 'NON-ENCRYPTED/'
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

	def public_addresses_file_path(file_type,usb=false)
		public_directory_path(usb)+public_addresses_file_name+$tag.to_s+"."+file_type
	end

	def private_keys_file_path(file_type,encrypted,usb=false)
		if encrypted
			return encrypted_directory_path(usb)+private_keys_file_name+$tag.to_s+"."+file_type+".aes"		
		else
			return unencrypted_directory_path(usb)+private_keys_file_name+$tag.to_s+"."+file_type
		end		
	end

	def password_shares_path(number,usb=false)
		raise 'Share number must be positive' unless number > 0
		encrypted_directory_path(usb)+password_share_file_name+'_'+number.to_s+$tag.to_s+'.csv'
	end
end