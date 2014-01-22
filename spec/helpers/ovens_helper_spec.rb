require 'spec_helper'

include CryptoHelper
include FilesHelper

describe OvensHelper do

	describe "load encrypted file:" do
		let!(:html) { '<html>foo</html>' }
		let!(:file) { encrypt_my_file(html,'bar') }
		let!(:path) { coldstorage_directory + 'test.html' }
		before do
			save_file(path,file)
		end
		describe "can load the file:" do
			let!(:loaded) { load_encrypted(path) }
			subject { loaded }
			it { should_not be_blank }
			describe "and the file can be encrypted:" do
				specify{decrypt_my_file(loaded,'bar').should == html}
				specify{decrypt_loaded(path,'bar').should == html}
			end			
		end
		after do
			delete_file(path)
		end
	end
	
	describe "trim CSS:" do
		let!(:bare_html) { '<html><head><title></title></head><body></body></html>' }
		let!(:full_html) { '<html><head><title></title></head><body></body><style type="text/css">foo</style></html>' }
		specify {trim_css(full_html).should == bare_html}
		specify {trim_css('foobar').should == 'foobar'}
		specify {trim_css('').should == ''}
		specify	{trim_css(nil).should == ''}
	end

	describe "extract relevant html" do
		let!(:full_html) { '<foo></foo><div class="heatup_begin">contentblah<div class="heatup_end"><bar></bar>' }
		let!(:trimmed) { 'contentblah' }
		specify {extract_keys_html(full_html).should == trimmed}
		specify {extract_keys_html('foobar').should == 'foobar'}
		specify {extract_keys_html('').should == ''}
		specify	{extract_keys_html(nil).should == ''}
	end

	describe "build_addresses_hash_array_from_csv" do
		let!(:addr_csv) { [["#", "Bitcoin Address"], ["1", "18KVUSLdn984nnf5DwBUEPFdUc6Ca2UErh"], ["2", "1Jhf5sVmuVDVh23UZFaVW267cMWYCCJxEG"]] }
		let!(:addr_hash) { build_addresses_hash_array(addr_csv) }
		subject { addr_hash }
		its(:length) { should == 2 }
		it { addr_hash[0][:addr].should == '18KVUSLdn984nnf5DwBUEPFdUc6Ca2UErh' }
		it { addr_hash[1][:addr].should == '1Jhf5sVmuVDVh23UZFaVW267cMWYCCJxEG' }
	end

	describe "build_private_keys_hash_array_from_csv" do
		let!(:pk_csv) { [["#", "Bitcoin Address", "Private Key"], ["1", "12fNHfnk1DvdMjrBbzjFd5WhEQWm68xM4K", "5J2PLz9ej2k7c1UEfQANfQgLsZnFVeY5HjZpnDe1n6QSKXy1zFQ"], ["2",  "1LTRtjXoU5pCgTDBMdFMKepuFRHB1Jan2Y",  "5KSfstJGVjkkpWm9Yi1aW2qbPg17KNxtKYQXeDfGwEYNcKZbRsV"]] }
		let!(:pk_hash) { build_private_keys_hash_array(pk_csv) }
		subject { pk_hash }
		its(:length) { should == 2 }
		it { pk_hash[0][:private_wif].should == '5J2PLz9ej2k7c1UEfQANfQgLsZnFVeY5HjZpnDe1n6QSKXy1zFQ' }
		it { pk_hash[1][:private_wif].should == '5KSfstJGVjkkpWm9Yi1aW2qbPg17KNxtKYQXeDfGwEYNcKZbRsV' }
		it { pk_hash[0][:addr].should == '12fNHfnk1DvdMjrBbzjFd5WhEQWm68xM4K' }
		it { pk_hash[1][:addr].should == '1LTRtjXoU5pCgTDBMdFMKepuFRHB1Jan2Y' }
	end	
 

end