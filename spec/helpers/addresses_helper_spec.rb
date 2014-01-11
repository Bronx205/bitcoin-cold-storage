require 'spec_helper'

describe AddressesHelper do

	describe "generate_qr" do
		specify {generate_qr('hello').to_s[0,50].should == "xxxxxxx xxxxxx x  x    xxxxx  x x xxxxxxx\nx     x "}
	end

end