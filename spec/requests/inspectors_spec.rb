require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

describe "Inspectors:" do
	let!(:test_pa_path) { file_fixtures_directory+'valid/10_addresses.csv' }
	let!(:test_unencrypted_pk_path) { file_fixtures_directory+'valid/10_private_keys.csv' }	
	let!(:test_encrypted_pk_path) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv.aes' }	
	let!(:test_decrypted_pk_path) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv' }	
	subject { page }
	before do
	  visit inspect_path
	end
	it_should_behave_like 'the inspect page'
	describe "loading an addresses csv file" do
		let!(:data) { CSV.read(test_pa_path) }
		before do
		  attach_file "file", test_pa_path
		  click_button inspect_button
		end
		it_should_behave_like 'the addresses page'
		it_should_behave_like 'it does not have download buttons'
		describe "and show the addresses correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
			it { should have_selector('td.text_pubkey#address_10', text: data[10][1]) }
			it { should_not have_selector('td.text_pubkey#address_11') }			
		end
	end
	describe "loading an unencrypted private keys csv file" do
		let!(:data) { CSV.read(test_unencrypted_pk_path) }
		before do
		  attach_file "file", test_unencrypted_pk_path
		  click_button inspect_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'		
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
			it { should have_selector('td.text_pubkey#address_10', text: data[10][1]) }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_11') }			
		end
	end
	describe "loading an encrypted private keys csv.aes file" do
		let!(:data) { CSV.read(test_decrypted_pk_path) }
		before do
		  attach_file "file", test_encrypted_pk_path
		  fill_in 'password', with: 'moohaha'
		  click_button inspect_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'		
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
			it { should have_selector('td.text_pubkey#address_2', text: data[2][1]) }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_11') }			
		end
	end	
	describe "invalid files" do
		describe "foo.bar" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/foo.bar'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: upload_format_error) }	
		end	
		describe "loading an address file with an invalid bitcoin address invalid_address.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_address.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading a file with an invalid addresses format invalid_addresses_format.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_addresses_format.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading an addresses file with an invalid header format invalid_addresses_header.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_addresses_header.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end	
		describe "loading a private keys file with an invalid_format" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_format.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading a file with an invalid header format invalid_header_format.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_header_format.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end	
		describe "loading an pkey file with an invalid format invalid_prvkey_format.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_prvkey_format.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end	
		describe "loading a private keys file with an invalid bitcoin address prkey_with_invalid_address" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/prkey_with_invalid_address.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading a prkey_with_non_matching_key_pairs" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/prkey_with_non_matching_key_pairs.csv'
			  click_button inspect_button			  
			end
			it_should_behave_like 'the inspect page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end											
	end

							
end
