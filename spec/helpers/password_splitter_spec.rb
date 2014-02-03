require 'spec_helper'

describe "password splitter" do
	# it { PasswordSplitter.should respond_to :join }
	let!(:splitter) { PasswordSplitter.new }
	subject { splitter }
	describe "attributes" do
		it { should respond_to :password }
		it { should respond_to :shares }
		it { should respond_to :k }
		it { should respond_to :n }
		it { should respond_to :join }
	end

	describe "default initializer" do
		its(:password) { should_not be_blank }
		its(:k) { should == 3 }
		its(:n) { should == 5 }
		its(:shares) { should_not be_nil }
		its(:shares) { should be_an_instance_of Array }
	end

	describe "initializer with a password" do
		let!(:splitter_with_pass) { PasswordSplitter.new(3,2,'foobar') }
		subject { splitter_with_pass }
		describe "should have the right attributes" do
			its(:password) { should == 'foobar' }
			its(:k) { should == 2 }
			it {splitter_with_pass.shares.length.should == 3}
		end
	end

	describe "k bigger than n" do
		it { expect{PasswordSplitter.new(3,4)}.to raise_error(ArgumentError, 'k must be smaller or equal than n') }
	end

	describe "join" do
		let!(:pg) { PasswordSplitter.new(3,2) }
		let!(:pass) { "I love yoO $$ a Bu$hel!! \n and \t peck...." }
		let!(:pgp) { PasswordSplitter.new(5,3,pass) }
		let!(:pg_shares_input_string) { pg.shares.drop(1).join("\n") }
		let!(:pgp_missing_shares_input_string) { pg.shares.drop(3).join("\n") }
		let!(:pgp_shares_input_string) { pgp.shares.drop(2).join("\n") }
		it "should raise error if not enough shares" do
			expect {pg.join(2,'123')}.to raise_error('Not enough shares')
			expect {pgp.join(3,pgp_missing_shares_input_string)}.to raise_error('Not enough shares')
		end
		it "should retrieve the password" do
			pg.join(2,pg_shares_input_string).should == pg.password	
			pgp.join(3,pgp_shares_input_string).should == pass
		end		
	end


end