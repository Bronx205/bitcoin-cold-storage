require 'spec_helper'
include CryptoHelper
include FreezersHelper

describe OvensHelper do

	describe "load encrypted file" do
		let!(:file) { encrypt_my_file('<html>foo</html>','bar') }
		let!(:path) { coldstorage_directory + 'test.txt' }
		before do
			save_file(path,file)
		end
		describe "can load a file" do
			let!(:loaded) { load_encrypted(path) }
			subject { loaded }
			it { should_not be_blank }
		end
		after do
			delete_file(path)
		end
	end



end