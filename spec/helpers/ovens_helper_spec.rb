require 'spec_helper'
include CryptoHelper
include FreezersHelper

describe OvensHelper do

	describe "load encrypted file:" do
		let!(:html) { '<html>foo</html>' }
		let!(:file) { encrypt_my_file(html,'bar') }
		let!(:path) { coldstorage_directory + 'test.html' }
		before do
			save_file(path,file)
		end
		describe "can load the file:" do
			let!(:loaded) { load_encrypted(path) }
			subject { loaded }
			it { should_not be_blank }
			describe "and the file can be encrypted:" do
				specify{decrypt_my_file(loaded,'bar').should == html}
				specify{decrypt_loaded(path,'bar').should == html}
			end			
		end
		after do
			delete_file(path)
		end
	end



end