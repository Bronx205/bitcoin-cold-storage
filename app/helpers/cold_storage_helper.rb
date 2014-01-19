module ColdStorageHelper

	def get_css_from_file
		file = File.join(Rails.root, 'app/helpers/download.css')
		File.read(file)
	end

	def inject_css(html_string,css_string=get_css_from_file)
		remove_tag=html_string[0..-(' </html>'.length)]
		insert_css=remove_tag<<'<style type="text/css">'<<css_string<<'</style></html>'		
	end

	def trim_css(html_string)
		string=html_string.to_s
		position=string.to_s.index('<style type="text/css">')
		if position 
			return string[0..(position-1)]+'</html>'
		else
			return string
		end			
	end

	def extract_keys_html(html_string)
		string=html_string.to_s
		start_mark='<div class="heatup_begin">'
		finish_mark='<div class="heatup_end">'
		start_index=string.index(start_mark)
		finish_index=string.index(finish_mark)
		start=start_index+start_mark.length if start_index
		finish=finish_index-1 if finish_index
		if start && finish && (finish > start)
			return string[start..finish]
		else
			return string
		end		
	end

	def save_file(path, data)
		File.open(path,'w') {|file| file.write data }
	end

	def delete_file(path)
		File.delete(path) if File.exist?(path)
	end	

	def save_coldstorage_files(plain_file,encrypted_file)
		save_file(plaintext_file_path,plain_file)
		save_file(encrypted_file_path,encrypted_file)
	end

	def relative_root_path
		File.expand_path(Rails.root)
	end

	def coldstorage_directory
		relative_root_path +  '/files/'
	end

	def plaintext_file_name
		'plaintext.html'
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def no_file_message
		'Decryption failed because the file '+ encrypted_file_name + ' was not found'
	end

	def plaintext_file_path
		coldstorage_directory+plaintext_file_name
	end

	def encrypted_file_path
		coldstorage_directory+encrypted_file_name
	end	

end