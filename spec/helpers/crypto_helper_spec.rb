require 'spec_helper'
include CryptoHelper

describe CryptoHelper do

	describe "generate key" do
		it "should generate a key" do
			AES.key.length.should == "60ab340389170b3899782f38dd76a3c3".length
		end
	end

	describe "encryption" do
		it "should encrypt" do
			AES.encrypt("A super secret message", 'foobar').length=="dSqQMRtFwrwQg1ZkTv48aw==$YfQJxI1q1QBGV5Al61h7ppYBvOkr+jGXtYtZrglhuPQ=".length
		end
	end

	describe "decryption" do
		it "should decrypt" do
			AES.decrypt(AES.encrypt("A super secret message", 'foobar'),'foobar').should =="A super secret message"
		end
	end

	describe "meta array" do
		specify {meta_array.length.should ==4}		
	end

	describe "strong password" do
		it {generate_strong_password(10).length.should == 10}
	end
	describe "encrypt my page" do
		it { encrypt_my_page('<html><head><title></title></head><body></body></html>','foo').should == 
		"xJtRlGTH7bJOjjFlUronyV/DJp0tNO+GSOSH6Xzl1svGbs7nZMQrdFsIyp4E\nILcCyvc/G3rkH0Mtdy8bOtGhbQ==\n"}
		it { encrypt_my_page('<html><head><title></title></head><body></body></html>','foo').should_not == 
		"xJtRlGTH7bJOjjFlUronyV/DJp0tNO+GSOSH6Xzl1svGbs7nZMQrdFsIyp4E\nILcCyvc/G3rkH0Mtdy8bOtGhbQ==\n1"}		
		it { AESCrypt.decrypt(encrypt_my_page('foo','bar'),'bar').should == 'foo'}
		it { AESCrypt.decrypt(encrypt_my_page('foo','bar'),'bar').should_not == 'fo'}
	end


end