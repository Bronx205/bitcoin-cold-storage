require 'spec_helper'

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

end