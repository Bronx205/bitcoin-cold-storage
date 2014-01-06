module ViewsHelper

	def app_title
		'Raspberry Pig'
	end

	def full_title(string)
		app_title + " - " + string
	end

	def setup_title
		'Setup'
	end

	def howmany_button_title
		'Generate Addresses'
	end

	def howmany_placeholder
		'How many?'
	end

	def private_title
		'Private'
	end

	def public_title
		'Public'
	end	

	def password_placeholder
		'Your password'
	end

	def password_button_title
		'submit'
	end
end