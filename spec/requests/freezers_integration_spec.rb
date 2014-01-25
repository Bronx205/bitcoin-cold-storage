require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Freezers" do
	let!(:pa_path) { public_addresses_file_path('csv') }
	let!(:pk_path) { private_keys_file_path('csv',false) }
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
			specify{File.exist?(pa_path).should be_true }			
			specify{(File.ctime(pa_path).to_f-Time.now.to_f).to_i.should be < 1}
			specify{File.exist?(pk_path).should be_true }
			specify{(File.ctime(pk_path).to_f-Time.now.to_f).to_i.should be < 1}					
		end
		describe "addresses view" do
			describe "should show in HTML the content of addresses.csv" do
				let!(:data) { CSV.read(pa_path) }
				before { visit addresses_path }
				it_should_behave_like 'the addresses page'
				it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
				describe "and redirect home if there is no such file" do
					before do
					  delete_file(pa_path)
					  visit addresses_path
					end
					it { should have_title(home_title) }
				end
			end
			describe "save addresses button should redirect home if no file" do
				before do
				  delete_file(pa_path)
				  click_link save_addresses_button
				end
				it { should have_title(home_title) }				
				it { should have_selector('div.alert.alert-error', text: missing_file_error) }				
			end
		end
		describe "private keys view" do
			describe "should show in HTML the content of private_keys.csv" do
				let!(:data) { CSV.read(pk_path) }
				before { visit private_keys_path }
				it_should_behave_like 'the private keys page'
				it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
				it { should have_selector('td.text_prvkey#prvkey_wif_1', text: data[1][2]) }
				describe "and redirect home if there is no such file" do
					before do
					  delete_file(pa_path)
					  visit private_keys_path
					end
					it { should have_title(home_title) }
				end				
			end
			describe "save private keys button should redirect home if no file" do
				before do
				  delete_file(pk_path)
				  click_link save_non_encrypted_button
				end
				it { should have_title(home_title) }
				it { should have_selector('div.alert.alert-error', text: missing_file_error) }				
			end			
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
