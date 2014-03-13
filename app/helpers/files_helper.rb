module FilesHelper
	require 'csv'
	require 'bitcoin'  

	def save_file(path, data)
		File.open(path,'w') {|file| file.write data }
	end

	def delete_file(path)
		File.delete(path) if File.exist?(path)
	end	

	def file_there?(path)
		File.exist?(path)
	end

	def read_address_csv(path)
		CSV.read(path,headers: true,col_sep: "\t").map do |row|
			[row[0],row[1]]
		end		
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
		!Dir.glob(password_shares_path(1)[0..-6]+'*'+tag+'.csv').empty?
		# !Dir.glob(password_shares_path(1)[0..-(tag.length+6)]+'*.csv').empty?
		# !Dir.glob('*'+tag+'.csv').empty?
	end

	def all_files_there?(tag='')
		tag=tag.to_s
		File.exists?(public_addresses_file_path('csv',tag)) &&
		File.exists?(private_keys_file_path('csv',false,tag)) &&
		File.exists?(private_keys_file_path('csv',true,tag)) &&
		!Dir.glob(password_shares_path(1)[0..-6]+'*'+tag+'.csv').empty?
		# !Dir.glob('*'+tag+'.csv').empty?
	end

# FileUtils.cp_r(coldstorage_directory,'/home/assaf/Desktop')

end