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

	def inspect_title
		'Inspect private keys in cold storage files'
	end
	
	def inspect_button
		'Inspect'
	end

	def freeze_title
		'Freeze'
	end

	def heatup_title
		'Heat-up'
	end

	def addresses_title
		'Bitcoin Addresses'
	end
	
	def private_keys_title
		'Private Keys'
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

	def password_flash_prefix
		"Your cold storage files where encrypted with the password ["
	end

	def strong_password_flash_prefix
		"Your cold storage files where encrypted with the randomly generated password ["
	end

	def password_flash_suffix
		"]. Please make a note of this password and keep a safely stored record."
	end

	def password_message(password,by_user)
		if by_user
			return password_flash_prefix+password+password_flash_suffix
		else
			return strong_password_flash_prefix+password+password_flash_suffix
		end
	end

	def catch_phrase
		'Simple Bitcoin Cold Storage'
	end

	def elevator_pitch
		'Create and recover encrypted addresses on your offline Raspberry Pi'
	end
	def addresses_range_notice
		'The number of addresses must be positive and no bigger than ' + KEYS_LIMIT.to_s + '.'
	end

	def entropy_explanation(length, alphabet, entropy)
		size=[(entropy -1).round.to_i,0].max.to_s
		'A brute force search for a word of length '+length.to_s + ' in the alphabet [' + alphabet.to_s + '] requires ~ 2^' + size + ' trials, on average.'
	end

	def save_non_encrypted_button
		'Save NON-ENCRYPTED'
	end

	def save_encrypted_button
		'Save encrypted'
	end

	def save_non_encrypted_title
		'Save a NON-ENCRYPTED copy'
	end

	def save_encrypted_title
		'Save an encrypted copy'
	end

	def save_addresses_button
		'Save a copy'
	end
	def save_private_keys_button
		save_addresses_button
	end

	def missing_file_error
		'An error occured, please try again'
	end
	def upload_format_error
		'Accepting only csv, html or aes file types'
	end
	def incorrect_format_flash
		'The uploaded file is not in the correct format'
	end
end