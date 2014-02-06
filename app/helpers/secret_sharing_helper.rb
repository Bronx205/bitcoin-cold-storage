module SecretSharingHelper
	
require 'secretsharing'

	def string_to_int_string(string)
		temp=string.bytes.map do |byte|
			if (10..99).include?(byte)
				'0'<<byte.to_s
			elsif (0..9).include?(byte)
				'00'<<byte.to_s
			else
				byte.to_s
			end
		end
		temp.unshift('100').join
	end

	def int_string_to_string(int_string)
		raise int_string.to_s + 'is not an int string' unless int_string?(int_string)
		int_string.to_s.scan(/\d{3}/).map(&:to_i).drop(1).pack('c*')
	end

	def int_string?(string)
		string=string.to_s
		return false unless (string.length)%3 == 0
		# string.each_char do |char|
		# 	return false unless ('0'.ord..'9'.ord).include?(char.ord)
		# end		
		string.match(/^\d*$/)[0] == string
	end
end