require 'spec_helper'
require 'shared_examples'
include ViewsHelper

describe "Addresses" do
	subject { page }
	before { visit root_path }
	it_should_behave_like 'default_setup'
	describe "submitting should stay on setup if the request was not a positive number is requested" do
		['',0,-5,'foo',nil].each do |example|
			before do
			  fill_in 'howmany', with: example
			  click_button howmany_button_title			  
			end
			it_should_behave_like 'default_setup'			
		end
	end
	describe "submitting should redirect to private if a positive number is requested" do
		before do
		  fill_in 'howmany', with: '2'
		  click_button howmany_button_title			  
		end
		it { should have_title private_title }
		describe "cookie persistance of howmany" do
			before { visit root_path }
			it { find_field('howmany').value.should == '2' }
			it { find_field('howmany').value.should_not == 1 }
		end
	end
	describe "private page should show the correct number of addresses" do
		let!(:num) { 2 }
		before do
		  fill_in 'howmany', with: num
		  click_button howmany_button_title			  
		end
		it { should have_title full_title(private_title) }
		it { should have_selector('th', text: 'Bitcoin Address') }		
		it { should have_selector('table.private_output#private_output') }						
		(1..2).each do |x|
			it { should have_selector("td#address_#{x}") }
			it { should have_selector("td#qr_address_#{x}") }
			it { should have_selector('div.qr_address') }
			it { should have_selector("td#prvkey_wif_#{x}") }
			it { should have_selector("td#qr_prvkey_wif_#{x}") }
			it { should have_selector('div.qr_prvkey') }				
		end
	end
end
