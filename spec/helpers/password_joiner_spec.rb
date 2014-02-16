require 'spec_helper'
require 'shamir-secret-sharing'

describe "password joiner" do
	let!(:splitter) { PasswordSplitter.new(5,3) }
	let!(:joiner) { PasswordJoiner.new(splitter.shares.drop(2).join("\n")) }
	subject { joiner }
	describe "attributes" do
		it { should respond_to :password }
	end

end