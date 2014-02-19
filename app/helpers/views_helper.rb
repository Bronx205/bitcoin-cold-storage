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
		'Generate Cold Storage Files'
	end

	def recover_addresses_button
		'Recover Addresses'
	end

	def howmany_placeholder
		'How many?'
	end

	def recover_passwd_placeholder
		'Enter password (encrypted files only)'
		# 'Your cold storage password'
	end	

	def shares_placeholder
		'Or, enter password shares (encrypted files only)'
		# 'Your cold storage password'
	end	
	
	def inspect_page_title
		'Upload Cold Storage files'
	end

	def inspect_page_header
		inspect_page_title
	end
	
	def upload_button
		'Upload'
	end

	def recover_button
		'Upload for inspection'
	end

	def upload_button_title
		inspect_page_title
	end

	def freeze_page_title
		'Generate Bitcoin Addresses for Cold Storage'
	end

	def freeze_page_header
		'Generate Cold Storage files'
	end
	
	def freeze_button
		'Freeze'
	end

	def freeze_button_title
		freeze_page_title
	end

	def heatup_title
		'Heat-up'
	end

	def heatup_button_title
		'Decrypt and inspect your Cold Stored Bitcoin Addresses'
	end
	
	def addresses_title
		'Bitcoin Addresses'
	end
	
	def private_keys_title
		'Private Keys'
	end

	def password_placeholder
		'Override our strong password with your own? (optional)'	
		# 'Your Password (optional)'
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
		'The number of addresses must be an interger between 1 and ' + KEYS_LIMIT.to_s
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
	def wrong_password_flash
		'Wrong password, try again'
	end
	def no_file_loaded_flash
		'No file was loaded'
	end
	def qr_button
		'QR code'
	end
	def qr_button_title
		"Show QR code"
	end
	def ssss_n_placeholder
		'total'
	end
	def ssss_k_placeholder
		'minimal'
	end
	def ssss_n_title
		'Total number of shares'
	end
	def ssss_k_title
		'Minimal number of shares needed for password retrieval'
	end
	def save_shares_button
		'Save Shares'
	end
	def at_least_two_shares_flash
		'Number of shares must be an interger between 2 and '+ SHARES_LIMIT.to_s
	end
	def k_not_smaller_than_n_flash
		'The number of shares required for password reconstruction must be smaller than the total number of shares'
	end
	def hot_message
		'Do NOT use these addresses for cold storgae! You are online! This is only a demonstration'
	end
end