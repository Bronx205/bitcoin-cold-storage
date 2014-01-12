require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include AddressesHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Addresses" do
	subject { page }
	before { visit setup_path }
	it_should_behave_like 'the setup page'
	it { should have_xpath("//input[@value=0]")}
	describe "submitting should stay on setup if the request was not a positive number is requested" do
		['',0,-5,'foo',nil].each do |example|
			before do
			  fill_in 'howmany', with: example
			  click_button generate_button			  
			end
			it_should_behave_like 'the setup page'			
		end
	end
	describe "submitting should redirect to private if a positive number is requested", slow: true  do
		before do
		  fill_in 'howmany', with: '2'
		  click_button generate_button			  
		end
		it { should have_title view_title }
	end
	describe "private page layout", slow: true  do
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button			  
		end		
		it_should_behave_like 'the view page'		
	end
	describe "directly clicking the private link should redirect home" do
		before { click_link view_title }
		it { should have_title home_title }
	end	
	describe "clicking the private link with addresses should remain on the page", slow: true do
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button		
		  click_link view_title	  
		end				
		it_should_behave_like 'the view page'
	end	
	describe "private page should show the correct number of addresses", slow: true do		
		before do
		  fill_in 'howmany', with: 2
		  click_button generate_button			  
		end
		it { should have_selector("td#address_1") }
		it { should have_selector("td#qr_address_2") }
		it { should have_selector("td#prvkey_wif_1") }
		it { should have_selector("td#qr_prvkey_wif_2") }
	end
	describe "submitting a user password should use that password", slow: true do
		before do
		  fill_in 'password', with: 'foobar'
		  fill_in 'howmany', with: 1
		  click_button generate_button
		end
		it { should have_title(view_title) }		
		it { should have_selector('h2#show_password', text: 'Encrypted with: [ foobar ]') }
		it { should have_selector('div.show_entropy', text: '37 bits' ) }
	end
	describe "not submitting a user password should encrypt with strong password", slow: true do
		before do
		  fill_in 'howmany', with: 1
		  click_button generate_button
		end
		it { should have_title(view_title) }
		it { should_not have_selector('h2#show_password', text: 'Encrypted with: []') }
		it { should have_selector('h2#show_password', text: 'Encrypted with: [') }
	end
	describe "navigating directly to the view page should redirect to setup" do
		before { visit view_path }
		it { should have_title(home_title) }
	end

	describe "Cold Storgae Files are saved and are fresh" do
		let!(:plain_path) { coldstorage_directory+plaintext_file_name }
		let!(:encrypted_path) { coldstorage_directory+plaintext_file_name }
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button		
		end
		specify{File.exist?(plain_path).should be_true }			
		specify{(File.ctime(plain_path).to_f-Time.now.to_f).to_i.should be < 1  }
		specify{File.exist?(encrypted_path).should be_true }
		specify{(File.ctime(encrypted_path).to_f-Time.now.to_f).to_i.should be < 1  }
	end
	describe "Plaintext file" do
		let!(:plain_path) { coldstorage_directory+plaintext_file_name }
		before do
			fill_in 'howmany', with: 1		  
			fill_in 'password', with: 'arikstein'
		  click_button generate_button		
		end
		describe "looks like the right HTML" do
			let!(:plainfile) { File.read(plain_path) }
			let!(:expected_prefix) { '<doctype></doctype><html><head><title>'+full_title(view_title)+'</title>' }
			let!(:expected_pass) { '<h2 id="show_password">Encrypted with: [ <div class="highlight_password">arikstein</div> ]' }
			subject { plainfile }
			it { should_not be_blank }
			specify {plainfile.index(expected_prefix).should == 0}
			specify {plainfile.index(expected_pass).should > 1000}
			specify {plainfile.index('You requested 1 address').should > 500}
			specify {plainfile.index('You requested 2 address').should be_nil}
		end
	end	
end
