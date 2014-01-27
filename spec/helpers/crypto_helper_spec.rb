require 'spec_helper'

describe CryptoHelper do

	describe "encrypt my file" do
		it { encrypt('<html><head><title></title></head><body></body></html>','foo').should == 
		"xJtRlGTH7bJOjjFlUronyV/DJp0tNO+GSOSH6Xzl1svGbs7nZMQrdFsIyp4E\nILcCyvc/G3rkH0Mtdy8bOtGhbQ==\n"}
		it { encrypt('<html><head><title></title></head><body></body></html>','foo').should_not == 
		"xJtRlGTH7bJOjjFlUronyV/DJp0tNO+GSOSH6Xzl1svGbs7nZMQrdFsIyp4E\nILcCyvc/G3rkH0Mtdy8bOtGhbQ==\n1"}		
		it { AESCrypt.decrypt(encrypt('foo','bar'),'bar').should == 'foo'}
		it { AESCrypt.decrypt(encrypt('foo','bar'),'bar').should_not == 'fo'}
	end
	describe "decrypt my file" do
		let!(:html) { '<html><head><title></title></head><body></body></html>' }
		it { decrypt(encrypt(html,'foo'),'foo').should == html }
		it { decrypt(encrypt(html,'foo'),'foo').should_not == html[0..-2] }
	end	


end