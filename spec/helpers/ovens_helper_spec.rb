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

end