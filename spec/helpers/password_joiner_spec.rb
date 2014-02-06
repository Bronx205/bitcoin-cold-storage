require 'spec_helper'

describe "password joiner" do
	let!(:splitter) { PasswordSplitter.new(5,3) }
	let!(:joiner) { PasswordJoiner.new(splitter.shares.drop(2).join("\n")) }
	subject { joiner }
	describe "attributes" do
		it { should respond_to :password }
	end
	describe "should retrieve the password" do
		5.times do |n|
			describe "given any 3 of the 5 shares" do
				let!(:s) { splitter.shares.rotate(n).drop(2).join("\n") }
				let!(:j) { PasswordJoiner.new(s) }
				# it { s.should be_nil}
				it { j.should be_nil}
				# it { j.password.should == splitter.password }	
			end			
		end
	end
end