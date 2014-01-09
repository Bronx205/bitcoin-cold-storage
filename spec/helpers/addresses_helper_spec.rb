require 'spec_helper'

describe AddressesHelper do

	describe "generate_qr" do
		specify {generate_qr('hello').to_s[0,50].should == "xxxxxxx     xx x   xx xx  x  xx   x  x  x xxxxxxx\n"}
	end

end