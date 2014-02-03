class Quartermaster
	include FilesHelper
	include CryptoHelper

	require 'bitcoin'

	attr_reader :keys

	def initialize(key_array)
		raise 'Invalid keys' unless valid_array?(key_array)
		@keys=key_array
	end

	def save_public_addresses
		header=['Bitcoin Address']
		data=addresses_array
		save_enum_csv(public_addresses_file_path('csv'),header,data)
	end

	def save_unencrypted_private_keys
		header=['Bitcoin Address','Private Key']
		data=private_keys_array
		save_enum_csv(private_keys_file_path('csv',false),header,data)
	end	

	def save_encrypted_private_keys(password)
		save_unencrypted_private_keys
		non_encrypted_file=CSV.read(private_keys_file_path('csv',false))
		encrypted_file=encrypt(non_encrypted_file,password)
		save_file(private_keys_file_path('csv',true),encrypted_file)
	end

	def save_password_shares(password, ssss_hash)
		header=['Password Share']
		data=[['foobar']]
		n=ssss_hash[:n]
		n.times do |count|
			save_csv(password_shares_path(count+1),header,data)
		end
	end


	def dump_files(password,ssss_hash)
		save_public_addresses
		save_unencrypted_private_keys
		save_encrypted_private_keys(password)
		save_password_shares(password,ssss_hash)
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