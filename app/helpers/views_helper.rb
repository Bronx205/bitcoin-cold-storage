module ViewsHelper

	def app_title
		'Raspberry Pig'
	end

	def full_title(string)
		app_title + " - " + string.to_s
	end

	def setup_title
		'Setup'
	end

	def home_title
		'Home'
	end

	def generate_button
		'Generate Addresses'
	end

	def howmany_placeholder
		'How many?'
	end

	def view_title
		'View'
	end

	def freeze_title
		'Freeze'
	end

	def heatup_title
		'Heat-up'
	end

	def password_placeholder
		'Your Password (optional)'
	end

	def entropy_explanation(length, alphabet, entropy)
		size=[(entropy -1).round.to_i,0].max.to_s
		'A brute force search for a word of length '+length.to_s + ' in the alphabet [' + alphabet.to_s + '] requires ~ 2^' + size + ' trials, on average.'
	end

	def get_css_from_file
		file = File.join(Rails.root, 'app/helpers/download.css')
		File.read(file)
	end

	def inject_css(html_string)
		remove_tag=html_string[0..-(' </html>'.length)]
		insert_css=remove_tag<<'<style type="text/css">'<<get_css_from_file<<'</style></html>'		
	end
end