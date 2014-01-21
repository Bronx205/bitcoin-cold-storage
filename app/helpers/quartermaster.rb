class Quartermaster
	include FilesHelper
	require 'bitcoin'

	attr_reader :keys

	def initialize(key_array=[])
		raise 'Invalid keys' unless valid_array?(key_array)
		@keys=key_array
	end

	def save_public_addresses
		header=['#','Bitcoin Address']
		result=[]
		CSV.open(public_addresses_file_path+".csv", "w", col_sep: "	") do |csv|		
			csv << header
			@keys.each do |key|
				result << @keys.index(key)
			end
			csv << result
		end
		result=[]
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

end

# CSV.read(p,headers: true,col_sep: "\t").map do |row|
# [row[0],row[1],row[2]]
# end