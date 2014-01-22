module ViewsHelper

	def app_title
		'CoinCooler'
	end

	def full_title(string)
		app_title + " - " + string.to_s
	end

	def home_title
		'Home'
	end

	def heatup_header
		'Recovered Addresses'
	end

	def failed_decryption_message
		'Decryption have failed. Try again..'
	end

	def generate_button
		'Generate Addresses'
	end

	def recover_button
		'Recover Addresses'
	end

	def howmany_placeholder
		'How many?'
	end

	def recover_passwd_placeholder
		'Your cold storage password'
	end	

	def cold_view_title
		'Inspect your new cold storage addresses'
	end

	def hot_view_title
		'Inspect the addresses recovered from cold storage'
	end	

	def freeze_title
		'Freeze'
	end

	def heatup_title
		'Heat-up'
	end

	def freeze_button_title
		'Generate an encrypted file containing Bitcoin Addresses for Cold Storage'
	end

	def heatup_button_title
		'Decrypt and inspect your Cold Stored Bitcoin Addresses'
	end

	def password_placeholder
		'Your Password (optional)'
	end

	def catch_phrase
		'Simple Bitcoin Cold Storage'
	end

	def elevator_pitch
		'Create and recover encrypted addresses on your offline Raspberry Pi'
	end
	def addresses_range_notice
		'You can request at most ' + ColdStorage.keys_limit.to_s + ' addresses.'
	end

	def entropy_explanation(length, alphabet, entropy)
		size=[(entropy -1).round.to_i,0].max.to_s
		'A brute force search for a word of length '+length.to_s + ' in the alphabet [' + alphabet.to_s + '] requires ~ 2^' + size + ' trials, on average.'
	end

  def clear_flash_messages
  	flash[:error].clear if flash[:error] 
  end	

end