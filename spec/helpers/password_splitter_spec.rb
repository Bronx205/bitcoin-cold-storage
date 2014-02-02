require 'spec_helper'

describe "password splitter" do
	let!(:splitter) { PasswordSplitter.new }
	subject { splitter }
	describe "attributes" do
		it { should respond_to :password }
		it { should respond_to :shares }
		it { should respond_to :k }
		it { should respond_to :n }
	end

	describe "default initializer" do
		its(:password) { should_not be_blank }
		its(:k) { should == 3 }
		its(:n) { should == 5 }
		its(:shares) { should be_nil }
	end

	describe "initializer with a password" do
		let!(:splitter_with_pass) { PasswordSplitter.new(3,2,'foobar') }
		subject { splitter_with_pass }
		describe "should have the right attributes" do
			its(:password) { should == 'foobar' }
			its(:k) { should == 2 }
		end
	end

	describe "k bigger than n" do
		it { expect{PasswordSplitter.new(3,4)}.to raise_error(ArgumentError, 'k must be smaller or equal than n') }
	end


end