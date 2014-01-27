module FilesHelper
	require 'csv'
	require 'bitcoin'

	def save_file(path, data)
		File.open(path,'w') {|file| file.write data }
	end

	def delete_file(path)
		File.delete(path) if File.exist?(path)
	end	

	def relative_root_path
		File.expand_path(Rails.root)
	end

	def file_there?(path)
		File.exist?(path)
	end

	def coldstorage_directory
		relative_root_path +  '/files/'
	end

	def file_fixtures_directory
		relative_root_path +  '/spec/fixtures/files/'
	end

	def plaintext_file_name
		public_addresses_file_path('html')
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def no_file_message
		'Decryption failed because the file '+ encrypted_file_name + ' was not found'
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

	def public_addresses_file_path(file_type)
		public_directory_path + public_addresses_file_name + "." + file_type
	end

	def private_keys_file_path(file_type,encrypted = true)
		if encrypted
			return encrypted_directory_path + private_keys_file_name + "." + file_type + ".aes"		
		else
			return unencrypted_directory_path + private_keys_file_name + "." + file_type
		end		
	end

	# def private_keys_file_path(file_type,encrypted? = false)
	# 	if encrypted?
	# 		temp = encrypted_directory_path
	# 	else
	# 		temp = unencrypted_directory_path
	# 	end
	# 	temp + private_keys_file_name + "." + file_type	
	# end

	def read_address_csv(path)
		CSV.read(path,headers: true,col_sep: "\t").map do |row|
			[row[0],row[1]]
		end		
	end

	def save_full_html(plain_file,encrypted_file)
		save_file(private_keys_file_path('html',false),plain_file)
		save_file(private_keys_file_path('html',true),encrypted_file)
	end	

	def save_csv(path,header_array,data_nested_array)
		CSV.open(path,"wb",col_sep: ",") do |csv|
			csv << header_array
			data_nested_array.each do |row|
				csv << row
			end
		end
	end
	def save_enum_csv(path,header_array,data_nested_array)
		CSV.open(path,"wb",col_sep: ",") do |csv|
			csv << header_array.unshift('#')
			data_nested_array.each do |row|
				csv << row.unshift(data_nested_array.index(row)+1)
			end
		end
	end
	def addresses_csv_format?(csv_data)
		return false if csv_data[0][0]!="#"
		return false if csv_data[0][1]!="Bitcoin Address"
		return false if csv_data[0][2]!=nil
		return false if csv_data[1][0]!="1"
		return false if csv_data[1][2]!=nil
		return false unless Bitcoin::valid_address?(csv_data[1][1])
		true
	end
	def private_keys_csv_format?(csv_data)
		return false if csv_data[0][0]!="#"
		return false if csv_data[0][1]!="Bitcoin Address"
		return false if csv_data[0][2]!="Private Key"
		return false if csv_data[0][3]!=nil
		return false if csv_data[1][0]!="1"
		return false if csv_data[1][3]!=nil
		return false unless Bitcoin::valid_address?(csv_data[1][1])
		return false unless Bitcoin::Key.from_base58(csv_data[1][2]).addr == csv_data[1][1]
		true
	end

	def clear_coldstorage_files
		delete_file(public_addresses_file_path('csv'))
		delete_file(private_keys_file_path('csv',false))
		delete_file(private_keys_file_path('csv',true))
	end
end