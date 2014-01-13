require 'spec_helper'

describe CryptoHelper do

	describe "meta array" do
		specify {meta_array.length.should ==4}		
	end

	describe "strong password" do
		it {generate_strong_password(10).length.should == 10}
	end
	describe "encrypt my file" do
		it { encrypt_my_file('<html><head><title></title></head><body></body></html>','foo').should == 
		"xJtRlGTH7bJOjjFlUronyV/DJp0tNO+GSOSH6Xzl1svGbs7nZMQrdFsIyp4E\nILcCyvc/G3rkH0Mtdy8bOtGhbQ==\n"}
		it { encrypt_my_file('<html><head><title></title></head><body></body></html>','foo').should_not == 
		"xJtRlGTH7bJOjjFlUronyV/DJp0tNO+GSOSH6Xzl1svGbs7nZMQrdFsIyp4E\nILcCyvc/G3rkH0Mtdy8bOtGhbQ==\n1"}		
		it { AESCrypt.decrypt(encrypt_my_file('foo','bar'),'bar').should == 'foo'}
		it { AESCrypt.decrypt(encrypt_my_file('foo','bar'),'bar').should_not == 'fo'}
	end
	describe "decrypt my file" do
		let!(:html) { '<html><head><title></title></head><body></body></html>' }
		it { decrypt_my_file(encrypt_my_file(html,'foo'),'foo').should == html }
		it { decrypt_my_file(encrypt_my_file(html,'foo'),'foo').should_not == html[0..-2] }
	end	


end