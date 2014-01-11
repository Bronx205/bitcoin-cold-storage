require 'spec_helper'
require 'shared_examples'
include ViewsHelper

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
		# describe "persistance of howmany" do
		# 	before { visit setup_path }
		# 	it { find_field('howmany').value.should == '2' }
		# 	it { find_field('howmany').value.should_not == 0 }
		# end
	end
	describe "private page layout", slow: true  do
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button			  
		end		
		it_should_behave_like 'the private page'		
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
		it_should_behave_like 'the private page'
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
	describe "navigating directly to the private page should redirect to setup" do
		before { visit view_path }
		it { should have_title(home_title) }
	end
end
