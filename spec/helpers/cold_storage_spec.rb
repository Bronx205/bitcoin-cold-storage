require 'spec_helper'

describe "cold storage" do
	let!(:cold) { ColdStorage.new(1,'foo') }
	subject { cold }
	describe "attributes" do
		it { should respond_to :howmany }
		it { should respond_to :password }
		it { should respond_to :keys }
	end
	describe "standard initializer" do
		let!(:cold2) { ColdStorage.new(2,'foo') }		
		subject { cold2 }
		its(:howmany) { should == 2 }
		its(:password) { should=='foo' }
		its(:keys) { should_not be_blank }
		it { cold2.keys.length.should == cold2.howmany }
		describe "keys array" do
			specify {Bitcoin::valid_address?(cold2.keys[0][:addr]).should be_true}	
			specify {Bitcoin::pubkey_to_address(cold2.keys[1][:pub]).should == cold2.keys[1][:addr]}	
		end
	end
	describe "funky initializer" do
		it {expect {ColdStorage.new }.to raise_error}		
		it {expect {ColdStorage.new(2) }.not_to raise_error}		
		it {expect {ColdStorage.new('foo') }.to raise_error}	
		it {expect {ColdStorage.new('foo',1) }.to raise_error}	
		it {expect {ColdStorage.new(-1,'foo') }.to raise_error}	
		it {expect {ColdStorage.new(nil,-1) }.to raise_error}	
		it {expect {ColdStorage.new(-1,nil) }.to raise_error}	
		it {expect {ColdStorage.new('foo','') }.to raise_error}	
		it {expect {ColdStorage.new('','foo') }.to raise_error}	
		it {expect {ColdStorage.new(nil,'') }.to raise_error}			
		it {expect {ColdStorage.new('',nil) }.to raise_error}			
	end

	describe "setting a user password" do
		describe "good value" do
			let!(:cold2) { ColdStorage.new(1,'bar') }
			subject { cold2 }
			its(:password) { should == 'bar' }
		end
		describe "numeric value" do
			let!(:cold2) { ColdStorage.new(1,1) }
			subject { cold2 }
			its(:password) { should == '1' }
		end		
	end

	describe "password:" do		
		describe "password should be user password if not blank" do
			let!(:cold2) { ColdStorage.new(1,'foo') }
			subject { cold2 }
			its(:password) { should == 'foo' }
			it { cold2.password.length.should_not == 30 }	
		end
	end

end