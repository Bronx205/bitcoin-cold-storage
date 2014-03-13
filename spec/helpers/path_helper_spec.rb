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

end