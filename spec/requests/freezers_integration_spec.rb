require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Freezers" do
	subject { page }
	before do
	  visit freeze_path
	end
	describe "submitting should redirect to view if a positive number is requested"  do
		before do
			fill_in 'howmany', 	with: 2		
			fill_in 'password', with: 'supercali'  
		  click_button generate_button	
		end		
		it_should_behave_like 'the private keys page'		
		it { should have_selector('div.alert.alert-password', text: 'supercali') }
		describe "and should show the correct number of rows" do
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }	
		end
	end
	describe "submitting without password should default to a strong password"  do
		before do
			fill_in 'howmany', 	with: 1		
		  click_button generate_button	
		end		
		it_should_behave_like 'the private keys page'		
		it { should have_selector('div.alert.alert-password', text: 'randomly generated') }
		describe "cold storage files are saved and are fresh" do
			let!(:pa_path) { public_addresses_file_path('csv') }
			let!(:pk_path) { private_keys_file_path('csv',false) }
			specify{File.exist?(pa_path).should be_true }			
			specify{(File.ctime(pa_path).to_f-Time.now.to_f).to_i.should be < 1}
			specify{File.exist?(pk_path).should be_true }
			specify{(File.ctime(pk_path).to_f-Time.now.to_f).to_i.should be < 1}					
		end		
	end
	describe "should not die on a big dispatch" do
		before do
			fill_in 'howmany', with: 10		  
		  click_button generate_button			  
		end		
		it_should_behave_like 'the private keys page'	
	end		
end
