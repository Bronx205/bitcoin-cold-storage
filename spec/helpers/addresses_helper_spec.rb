require 'spec_helper'

describe AddressesHelper do
	describe "generate_address_hash" do
		subject { hash }
		let!(:hash) { generate_address_hash }
		its(:class) { should == Hash }
		its(:length) { should == 3 } 
		specify { Bitcoin::valid_address?(hash[:address].should be_true) }
		specify { Bitcoin::pubkey_to_address(hash[:pubkey]).should == hash[:address] }
		# specify { hash[:qr_address].class.should == RQRCode::QRCode }			
		# specify { hash[:qr_prvkey].class.should == RQRCode::QRCode }		
	end

	describe "generate addresses array" do
		subject { addresses_array }
		let!(:howmany) { 1 }
		let!(:addresses_array) { generate_addresses_array(howmany) }
		its(:class) { should == Array }
		its(:length) { should == howmany }		
	end
end