module FilesHelper
	require 'csv'

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

	def plaintext_file_name
		'addresses.html'
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def no_file_message
		'Decryption failed because the file '+ encrypted_file_name + ' was not found'
	end

	def plaintext_file_path
		public_directory_path+plaintext_file_name
	end

	def encrypted_file_path
		coldstorage_directory+encrypted_file_name
	end	

	def public_directory_path
		coldstorage_directory + 'public/'
	end
			
	def private_directory_path
		coldstorage_directory + 'PRIVATE/'
	end

	def public_addresses_file_name
		'addresses.csv'
	end
	def private_keys_file_name
		'private_keys.csv'
	end	

	def public_addresses_file_path
		public_directory_path + public_addresses_file_name
	end

	def private_keys_file_path
		private_directory_path + private_keys_file_name
	end

	def read_address_csv(path)
		CSV.read(path,headers: true,col_sep: "\t").map do |row|
			[row[0],row[1]]
		end		
	end

	def save_full_html(plain_file,encrypted_file)
		save_file(plaintext_file_path,plain_file)
		save_file(encrypted_file_path,encrypted_file)
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

end