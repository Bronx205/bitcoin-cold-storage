require 'spec_helper'

describe PathHelper do

	describe "path selection" do
		it "should choose the right path for unencrypted" do
			private_keys_file_path('foo',false).should == unencrypted_directory_path + private_keys_file_name + '.foo'
		end
		it "should choose the right path for encrypted" do
			private_keys_file_path('foo').should == encrypted_directory_path + private_keys_file_name + '.foo.aes'
		end		
	end
	describe "usb vs internal path selection" do
		it "should work for public dir" do			
			public_directory_path.should == relative_root_path +  '/files/public/'
			public_directory_path(true).should == usb_path +  'public/'
		end
		it "should work for public file path" do			
			public_addresses_file_path('csv').should == relative_root_path +  '/files/public/' +public_addresses_file_name+'.csv'
			public_directory_path(true).should == usb_path +  'public/'
		end		
	end

end