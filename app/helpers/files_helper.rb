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
	def password_share_file_name
		'password_share'
	end

	def public_addresses_file_path(file_type,tag='')
		public_directory_path+public_addresses_file_name+tag.to_s+"."+file_type
	end

	def private_keys_file_path(file_type,encrypted = true,tag='')
		if encrypted
			return encrypted_directory_path+private_keys_file_name+tag.to_s+"."+file_type+".aes"		
		else
			return unencrypted_directory_path+private_keys_file_name+tag.to_s+"."+file_type
		end		
	end

	def password_shares_path(number,tag='')
		raise 'Share number must be positive' unless number > 0
		encrypted_directory_path+password_share_file_name+'_'+number.to_s+tag.to_s+'.csv'
	end

	def read_address_csv(path)
		CSV.read(path,headers: true,col_sep: "\t").map do |row|
			[row[0],row[1]]
		end		
	end

	# def save_full_html(plain_file,encrypted_file)
	# 	save_file(private_keys_file_path('html',false),plain_file)
	# 	save_file(private_keys_file_path('html',true),encrypted_file)
	# end	

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

	def nuke_coldstorage_directory
		FileUtils.rm_rf(Dir["#{public_directory_path}*.csv"])
		FileUtils.rm_rf(Dir["#{encrypted_directory_path}*.aes"])
		FileUtils.rm_rf(Dir["#{encrypted_directory_path}*.csv"])
		FileUtils.rm_rf(Dir["#{unencrypted_directory_path}*.csv"])
	end

	def clear_coldstorage_files(tag='')
		tag=tag.to_s
		delete_file(public_addresses_file_path('csv',tag))
		delete_file(private_keys_file_path('csv',false,tag))
		delete_file(private_keys_file_path('csv',true,tag))
		FileUtils.rm Dir[password_shares_path(1,tag)[0..-(tag.length+6)]+'*.csv']
		# FileUtils.rm Dir['*'+tag+'.csv']
	end

	def files_exist?(tag='')
		tag=tag.to_s
		File.exists?(public_addresses_file_path('csv',tag)) ||
		File.exists?(private_keys_file_path('csv',false,tag)) ||
		File.exists?(private_keys_file_path('csv',true,tag)) ||
		!Dir.glob(password_shares_path(1)[0..-(tag.length+6)]+'*.csv').empty?
		# !Dir.glob('*'+tag+'.csv').empty?
	end


end