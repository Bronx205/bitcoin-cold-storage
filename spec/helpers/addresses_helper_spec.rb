require 'spec_helper'

describe AddressesHelper do

	describe "generate addresses array" do
		subject { addresses_array }
		let!(:howmany) { 2 }
		let!(:addresses_array) { generate_addresses_array(howmany) }
		its(:class) { should == Array }
		its(:length) { should == howmany }	
		specify {Bitcoin::valid_address?(addresses_array[0][:addr]).should be_true}	
		specify {Bitcoin::pubkey_to_address(addresses_array[1][:pub]).should == addresses_array[1][:addr]}	
	end

	describe "generate_qr" do
		specify {generate_qr('hello').to_s[0,50].should == "xxxxxxx     xx x   xx xx  x  xx   x  x  x xxxxxxx\n"}
	end

	describe "set amout" do
		specify {set_amount(1).should==1}
		specify {set_amount(-1).should==1}
		specify {set_amount(nil).should==1}
		specify {set_amount('').should==1}
		specify {set_amount('foo').should==1}
	end
end