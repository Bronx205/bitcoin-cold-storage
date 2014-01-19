module OvensHelper

	include ColdStorageHelper

	def load_encrypted(path=encrypted_file_path)		
		File.read(path) if file_there?(path)
	end

	def decrypt_loaded(path=encrypted_file_path,password)
		decrypt_my_file(load_encrypted(path),password)
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

end
