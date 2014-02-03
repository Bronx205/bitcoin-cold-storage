require 'spec_helper'
require 'secretsharing'

describe SecretSharingHelper do

	describe "a split random secret can be retrieved" do
		let!(:ss1) { SecretSharing::Shamir.new(5,3) }
		let!(:secret) { ss1.create_random_secret }
		let!(:shares) { ss1.shares }
		let!(:retrieved1) { SecretSharing::Shamir.new(3) }
		subject { retrieved1 }
		describe "putting in just two of the shares should not retrieve the secret" do
			before do
				retrieved1 << shares[0]
				retrieved1 << shares[1]
			end			
			it { retrieved1.secret.should be_nil }
		end
		describe "putting in all 4 shares should retrieve the secret" do
			before do
				retrieved1 << shares[0]
				retrieved1 << shares[1]
				retrieved1 << shares[2]
			end			
			it { retrieved1.secret.should == secret }
		end
	end

	['foobar','I like Mike', 'foobarbuz \n quuax', 'is this password too looooong $$','a'*100,'123'].each do |example|
		describe "splittin the string"+example+"can be retrieved" do		
			let!(:ss) { SecretSharing::Shamir.new(3,2) }
			let!(:secret) { ss.set_fixed_secret(string_to_int_string(example)) }
			let!(:shares) { ss.shares }
			let!(:retrieved) { SecretSharing::Shamir.new(2) }
			subject { retrieved }
			describe "putting in just one of the shares should not retrieve the secret" do
				before do
					retrieved << shares[0]
				end			
				it { retrieved.secret.should be_nil }
			end
			describe "putting in 2 shares should retrieve the secret" do
				before do
					retrieved << shares[0]
					retrieved << shares[1]
				end				
				it { int_string_to_string(retrieved.secret.to_s).should == example }			
			end			
		end
	end

	describe "a split long string secret can be retrieved" do
		let!(:ss3) { SecretSharing::Shamir.new(5,3) }
		let!(:secret) { ss3.set_fixed_secret(string_to_int_string(example2)) }
		let!(:shares) { ss3.shares }
		let!(:retrieved3) { SecretSharing::Shamir.new(3) }
		subject { retrieved3 }
		describe "putting in just two of the shares should not retrieve the secret" do
			before do
				retrieved3 << shares[0]
				retrieved3 << shares[1]
			end			
			it { retrieved3.secret.should be_nil }
		end
		describe "putting in all 4 shares should retrieve the secret" do
			before do
				retrieved3 << shares[0]
				retrieved3 << shares[1]
				retrieved3 << shares[2]
			end				
			it { int_string_to_string(retrieved3.secret.to_s).should == example2 }			
		end
	end

	describe "an error is raised if secret is too long" do
		let!(:ss4) { SecretSharing::Shamir.new(5,3) }
		it { expect{ss4.set_fixed_secret(string_to_int_string(example1))}.to raise_error(RuntimeError,'max bitlength is 1024' ) }
	end

	describe "string_to_int_string" do
		it {string_to_int_string('foo').should == '100102111111'}
		it {string_to_int_string('a').should == '100097'}
		it {string_to_int_string('I want $100').should == '100073032119097110116032036049048048' }
		it {string_to_int_string('a\n').should_not == '100097'}
		it {string_to_int_string('a\n').should_not == string_to_int_string('a\n\n')}
		it {string_to_int_string('a s').should_not == string_to_int_string('a  s')}
		it {string_to_int_string('1').should == '100049'}
		it { string_to_int_string(example1).should == example1_int.to_s }
	end

	describe "int_string?" do
		it { int_string?('1').should_not be_true }
		it { int_string?('12').should_not be_true }
		it { int_string?('123').should be_true }
		it { int_string?('1234').should_not be_true }
		it { int_string?('001').should be_true }
		it { int_string?('911').should be_true }
		it { int_string?('012345').should be_true }
		it { int_string?('967589').should be_true }
		it { int_string?('f').should be_false }
		it { int_string?('$').should be_false }
		it { int_string?('Z').should be_false }
		it { int_string?('9675895 ').should be_false }
		it { int_string?('9675i895').should be_false }
		it { int_string?(string_to_int_string(example1)).should be_true }
		it { int_string?(string_to_int_string(example2)).should be_true }
	end

	describe "int_string_to_string" do
		it {expect {int_string_to_string('123f') }.to raise_error(/not an int string/)}
		it {int_string_to_string('100102111111').should == 'foo'}
		it {int_string_to_string('100097').should == 'a'}
		it {int_string_to_string('100073032119097110116032036049048048').should == 'I want $100' }	
		it {int_string_to_string(example1_int.to_s).should == example1 }	
		it { int_string_to_string(string_to_int_string('foo')).should == 'foo'}
		it { int_string_to_string(string_to_int_string('assaf Shomer\n\t$!@#')).should == 'assaf Shomer\n\t$!@#'}
		it { int_string_to_string(string_to_int_string('Z')).should == 'Z'}
	end

	# describe "foo" do
	# 	it {string_to_int_string(example1).should == example1_int}
	# end

	


	private

		def example1
			'Byte manipulation in Ruby

			Recently I\'ve been working through the cryptography exercises by the guys at Matasano Security. Many of these involve feeding crafted ciphertext to an oracle function with the purpose of garnering some information about the encryption process.

			Crafting the ciphertext involves manipulating data at the byte-level, for which ruby provides a few helpful tools.

			Integers with different bases
			Literals
			It can be useful to to be able to type integer literals in different bases in your code:'
		end

		def example1_int
			'100066121116101032109097110105112117108097116105111110032105110032082117098121010010009009009082101099101110116108121032073039118101032098101101110032119111114107105110103032116104114111117103104032116104101032099114121112116111103114097112104121032101120101114099105115101115032098121032116104101032103117121115032097116032077097116097115097110111032083101099117114105116121046032077097110121032111102032116104101115101032105110118111108118101032102101101100105110103032099114097102116101100032099105112104101114116101120116032116111032097110032111114097099108101032102117110099116105111110032119105116104032116104101032112117114112111115101032111102032103097114110101114105110103032115111109101032105110102111114109097116105111110032097098111117116032116104101032101110099114121112116105111110032112114111099101115115046010010009009009067114097102116105110103032116104101032099105112104101114116101120116032105110118111108118101115032109097110105112117108097116105110103032100097116097032097116032116104101032098121116101045108101118101108044032102111114032119104105099104032114117098121032112114111118105100101115032097032102101119032104101108112102117108032116111111108115046010010009009009073110116101103101114115032119105116104032100105102102101114101110116032098097115101115010009009009076105116101114097108115010009009009073116032099097110032098101032117115101102117108032116111032116111032098101032097098108101032116111032116121112101032105110116101103101114032108105116101114097108115032105110032100105102102101114101110116032098097115101115032105110032121111117114032099111100101058'
		end

		def example2
			'Byte manipulation in Ruby

						Recently I\'ve been working through the cryptography exercises by the guys at Matasano Security.'[0,100]
		end

end