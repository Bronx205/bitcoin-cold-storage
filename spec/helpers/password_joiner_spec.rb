require 'spec_helper'
require 'shamir-secret-sharing'

describe "password joiner" do
	let!(:pass) { 'fo0BAA$rbuz!quaax' }
	let!(:splitter) { PasswordSplitter.new(5,3,pass) }
	let!(:joiner) { PasswordJoiner.new(splitter.shares.drop(2)) }
	subject { joiner }
	describe "attributes" do
		it { should respond_to :password }
		its(:password) { should==pass }
	end
	describe "init with string" do
		it "should raise an error" do
			expect{PasswordJoiner.new('foo')}.to raise_error(RuntimeError)
		end
	end
	describe "init with number" do
		it "should raise an error" do
			expect{PasswordJoiner.new(1)}.to raise_error(RuntimeError)
		end
	end
	describe "init with fake shares should leave the password nil" do
		it { PasswordJoiner.new([1]).password.should be_nil}
		it { PasswordJoiner.new([1,2,3]).password.should be_nil}
	end
	it "Joiner should be able to retrieve pass out of any valid combo" do			
		splitter.shares.combination(3).each do |combo|
			PasswordJoiner.new(combo).password.should == pass
		end			
	end	
	it "Joiner should not be able to retrieve from just 2 shares" do			
		splitter.shares.combination(2).each do |combo|
			PasswordJoiner.new(combo).password.should be_nil
		end			
	end
	describe "joiner should retrieve splitter random password" do
		it { PasswordJoiner.new(PasswordSplitter.new.shares.drop(2)).should_not be_nil }
	end

end