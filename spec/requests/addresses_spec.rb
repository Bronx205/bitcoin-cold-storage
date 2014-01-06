require 'spec_helper'
require 'shared_examples'
include ViewsHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Addresses" do
	subject { page }
	before { visit root_path }
	it_should_behave_like 'default_setup'
	it { should have_xpath("//input[@value=1]")}
	describe "submitting should stay on setup if the request was not a positive number is requested" do
		['',0,-5,'foo',nil].each do |example|
			before do
			  fill_in 'howmany', with: example
			  click_button howmany_button_title			  
			end
			it_should_behave_like 'default_setup'			
		end
	end
	describe "submitting should redirect to private if a positive number is requested", slow: true  do
		before do
		  fill_in 'howmany', with: '2'
		  click_button howmany_button_title			  
		end
		it { should have_title private_title }
		describe "persistance of howmany" do
			before { visit root_path }
			it { find_field('howmany').value.should == '2' }
			it { find_field('howmany').value.should_not == 1 }
		end
	end
	describe "private page layout", slow: true  do
		before do
			fill_in 'howmany', with: 1		  
		  click_button howmany_button_title			  
		end		
		it_should_behave_like 'the private page'		
		describe "reload" do
			before { visit current_path }
			it_should_behave_like 'the private page'
		end
	end
	describe "private page should show the correct number of addresses", slow: true do		
		before do
		  fill_in 'howmany', with: 2
		  click_button howmany_button_title			  
		end
		it { should have_selector("td#address_1") }
		it { should have_selector("td#qr_address_2") }
		it { should have_selector("td#prvkey_wif_1") }
		it { should have_selector("td#qr_prvkey_wif_2") }
	end
end
