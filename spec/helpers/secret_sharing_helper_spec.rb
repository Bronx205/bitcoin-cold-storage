require 'spec_helper'
require 'secretsharing'

describe SecretSharingHelper do

	describe "a split password can be retrieved" do
		let!(:ss) { SecretSharing::Shamir.new(5,3) }
		let!(:secret) { ss.create_random_secret }
		let!(:shares) { ss.shares }
		let!(:retrieved) { SecretSharing::Shamir.new(3) }
		subject { retrieved }
		describe "putting in just two of the shares should not retrieve the secret" do
			before do
				retrieved << shares[0]
				retrieved << shares[1]
			end			
			it { retrieved.secret.should be_nil }
		end
		describe "putting in all 4 shares should retrieve the secret" do
			before do
				retrieved << shares[0]
				retrieved << shares[3]
				retrieved << shares[4]
			end			
			it { retrieved.secret.should == secret }
		end
	end

	# describe "string_to_int" do
	# 	string_to_int('foo').should == 
	# end
end