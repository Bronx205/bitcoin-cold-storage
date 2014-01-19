require 'spec_helper'

describe "cold storage" do
	let!(:cold) { ColdStorage.new }
	subject { cold }
	describe "attributes" do
		it { should respond_to :user_password }
		it { should respond_to :howmany }
		it { should respond_to :password }
		it { should respond_to :entropy }
		it { should respond_to :keys }
	end

	describe "initializer" do
		let!(:cold2) { ColdStorage.new('foo',2) }		
		subject { cold2 }
		its(:howmany) { should == 2 }
		its(:user_password) { should=='foo' }
		its(:keys) { should_not be_blank }		
		it { cold2.keys.length.should == cold2.howmany }
		describe "keys array" do
			specify {Bitcoin::valid_address?(cold2.keys[0][:addr]).should be_true}	
			specify {Bitcoin::pubkey_to_address(cold2.keys[1][:pub]).should == cold2.keys[1][:addr]}	
		end
	end

	describe "empty initializer" do
		its(:howmany) { should == 0 }
		its(:user_password) { should be_blank }
		its(:keys) { should be_blank }
	end

	describe "howmany should be 0 at minimum" do
		describe "good value" do
			let!(:cold2) { ColdStorage.new(nil,1) }
			subject { cold2 }
			its(:howmany) { should == 1 }
		end
		describe "negatvie value" do
			let!(:cold2) { ColdStorage.new(nil,-1) }
			subject { cold2 }
			its(:howmany) { should == 0 }
		end
		describe "string value" do
			let!(:cold2) { ColdStorage.new(nil,'foo') }
			subject { cold2 }
			its(:howmany) { should == 0 }
		end
		describe "blank value" do
			let!(:cold2) { ColdStorage.new(nil,'') }
			subject { cold2 }
			its(:howmany) { should == 0 }
		end
		describe "nil value" do
			let!(:cold2) { ColdStorage.new(nil,nil) }
			subject { cold2 }
			its(:howmany) { should == 0 }
		end								
	end	

	describe "setting a user password" do
		describe "good value" do
			let!(:cold2) { ColdStorage.new('bar') }
			subject { cold2 }
			its(:user_password) { should == 'bar' }
		end
		describe "nil value" do
			let!(:cold2) { ColdStorage.new(nil) }
			subject { cold2 }
			its(:user_password) { should == '' }
		end		
		describe "numeric value" do
			let!(:cold2) { ColdStorage.new(1) }
			subject { cold2 }
			its(:user_password) { should == '1' }
		end		
	end

	describe "password:" do
		its(:password) { should_not be_blank }
		it { cold.password.length.should == 30 }
		describe "password should be user password if not blank" do
			let!(:cold2) { ColdStorage.new('foo') }
			subject { cold2 }
			its(:password) { should == 'foo' }
			it { cold2.password.length.should_not == 30 }	
		end
	end

end