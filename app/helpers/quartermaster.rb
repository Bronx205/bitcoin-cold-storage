class Quartermaster
	include FilesHelper
	require 'bitcoin'

	attr_reader :keys

	def initialize(key_array=[])
		raise 'Invalid keys' unless valid_array?(key_array)
		@keys=key_array
	end

	def save_public_addresses
		header=['Bitcoin Address']
		data=addresses_array
		save_enum_csv(public_addresses_file_path('csv'),header,data)
	end

	def save_private_keys
		header=['Bitcoin Address','Private Key']
		data=private_keys_array
		save_enum_csv(private_keys_file_path('csv',false),header,data)
	end	

	def dump_files
		save_private_keys
		save_public_addresses
	end

	private
		def valid_array?(key_array)
			return false unless key_array.class == Array
			return false if key_array.blank?
			key_array.each do |key|
				return false unless key.class == Bitcoin::Key
			end
			return true
		end

		def addresses_array
			result=[]
			@keys.each do |key|
				result << [key.addr]
			end
			result
		end

		def private_keys_array
			result=[]
			@keys.each do |key|
				result << [key.addr,key.to_base58]
			end
			result
		end		
end

# CSV.read(p,headers: true,col_sep: "\t").map do |row|
# [row[0],row[1],row[2]]
# end