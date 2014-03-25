require 'spec_helper'

describe "password generator" do
	let!(:pass) { PasswordGenerator.new }
	let!(:alphabet) { pass.alphabet }
	let!(:eunit) { Math.log(alphabet.length,2) }
	subject { pass }
	describe "attributes" do
		it { should respond_to :password }
		it { should respond_to :entropy }
	end

	describe "initializer" do
		its(:entropy) { should == 40 * eunit }
	end

	describe "alphabet" do		
		subject { pass.alphabet }
		its(:class) { should == String }
		its(:length) { should == 71 }
	end

	describe "in alphabet?" do
		specify {pass.in_alphabet?('a').should be_true}
		specify {pass.in_alphabet?('!').should be_true}
		specify {pass.in_alphabet?('B').should be_true}
		specify {pass.in_alphabet?('4').should be_true}
		specify {pass.in_alphabet?('a4!A123@$').should be_true}
		specify {pass.in_alphabet?('!@$').should be_true}		
		specify {pass.in_alphabet?('a4!@$').should be_true}
		specify {pass.in_alphabet?('vS6Il1!h$e&q4x^B%rF7J+Mz9~k5uZ').should be_true}		 
		specify {pass.in_alphabet?('').should be_true}
		specify {pass.in_alphabet?(' ').should be_false}
		specify {pass.in_alphabet?('[').should be_false}
		specify {pass.in_alphabet?('(').should be_false}		
		specify {pass.in_alphabet?('}').should be_false}
		specify {pass.in_alphabet?('`').should be_false}			
		specify {pass.in_alphabet?('a 4!@#$').should be_false}
		specify {pass.in_alphabet?('a(4!@#$').should be_false}

		specify {pass.in_alphabet?('abc','def').should be_false}
		specify {pass.in_alphabet?('abc','abcd').should be_true}
		specify {pass.in_alphabet?('abc','abd').should be_false}
	end
	
	describe "calculate entropy" do
		specify {pass.calculate_entropy('').should == 0}
		specify {pass.calculate_entropy('a').should == eunit }
		specify {pass.calculate_entropy(' ').should == -1 }
		specify {pass.calculate_entropy('abc').should == 3*eunit }
	end

	describe "meta array" do
		specify {pass.meta_array.length.should ==4}		
	end

	describe "strong password" do
		let!(:p) { PasswordGenerator.new(10) }
		it {p.password.length.should == 10}
	end
end