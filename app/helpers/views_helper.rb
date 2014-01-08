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

	def generate_button
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
		'Password: ' + @coldstorage.strong_password
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