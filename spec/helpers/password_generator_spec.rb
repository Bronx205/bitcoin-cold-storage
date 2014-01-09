require 'spec_helper'

describe "password generator" do
	let!(:pass) { PasswordGenerator.new }
	let!(:alphabet) { PasswordGenerator.alphabet }
	let!(:eunit) { Math.log(alphabet.length,2) }
	subject { pass }
	describe "attributes" do
		it { should respond_to :password }
		it { should respond_to :entropy }
	end

	describe "initializer" do
		its(:entropy) { should == 30 * eunit }
	end

	describe "alphabet" do		
		subject { alphabet }
		its(:class) { should == String }
		its(:length) { should == 72 }
	end

	describe "in alphabet?" do
		specify {PasswordGenerator.in_alphabet?('a').should be_true}
		specify {PasswordGenerator.in_alphabet?('!').should be_true}
		specify {PasswordGenerator.in_alphabet?('B').should be_true}
		specify {PasswordGenerator.in_alphabet?('4').should be_true}
		specify {PasswordGenerator.in_alphabet?('a4!A123@#$').should be_true}
		specify {PasswordGenerator.in_alphabet?('!@#$').should be_true}		
		specify {PasswordGenerator.in_alphabet?('a4!@#$').should be_true}
		specify {PasswordGenerator.in_alphabet?('vS6Il1!h$e&q4x^B%rF7J+Mz9~k5uZ').should be_true}		 
		specify {PasswordGenerator.in_alphabet?('').should be_true}
		specify {PasswordGenerator.in_alphabet?(' ').should be_false}
		specify {PasswordGenerator.in_alphabet?('[').should be_false}
		specify {PasswordGenerator.in_alphabet?('(').should be_false}		
		specify {PasswordGenerator.in_alphabet?('}').should be_false}
		specify {PasswordGenerator.in_alphabet?('`').should be_false}			
		specify {PasswordGenerator.in_alphabet?('a 4!@#$').should be_false}
		specify {PasswordGenerator.in_alphabet?('a(4!@#$').should be_false}
	end
	
	describe "calculate entropy" do
		specify {PasswordGenerator.calculate_entropy('').should == 0}
		specify {PasswordGenerator.calculate_entropy('a').should == eunit }
		specify {PasswordGenerator.calculate_entropy(' ').should == -1 }
		specify {PasswordGenerator.calculate_entropy('abc').should == 3*eunit }
	end

end