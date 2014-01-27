require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Freezers" do
	let!(:pa_path) { public_addresses_file_path('csv') }
	let!(:non_encrypted_pk_path) { private_keys_file_path('csv',false) }
	let!(:encrypted_pk_path) { private_keys_file_path('csv',true) }
	subject { page }
	before do
		clear_coldstorage_files
	  visit freeze_path
	end
	describe "submitting should redirect to view if a positive number is requested"  do
		before do
			fill_in 'howmany', 	with: 2		
			fill_in 'password', with: 'supercali'  
		  click_button generate_button	
		end		
		it_should_behave_like 'it saved the files'
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it has download buttons'
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
		it_should_behave_like 'it has download buttons'	
		it { should have_selector('div.alert.alert-password', text: 'randomly generated') }			
	end
	describe "views" do
		before do
			fill_in 'howmany', 	with: 2		
			fill_in 'password', with: 'moooohaha'  
		  click_button generate_button	
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
				let!(:data) { CSV.read(non_encrypted_pk_path) }
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
			describe "save unencrypted button should redirect home if no file" do
				before do
				  delete_file(non_encrypted_pk_path)
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
		it_should_behave_like 'it has download buttons'
	end		
end
