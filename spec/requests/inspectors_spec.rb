require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

describe "Inspectors:" do
	let!(:test_pa_path) { file_fixtures_directory+public_addresses_file_name+'.csv' }
	let!(:test_pk_path) { file_fixtures_directory+private_keys_file_name+'.csv' }
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
	describe "loading a private keys csv file" do
		let!(:data) { CSV.read(test_pk_path) }
		before do
		  attach_file "file", test_pk_path
		  click_button inspect_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'		
		describe "and show the addresses correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
			it { should have_selector('td.text_pubkey#address_10', text: data[10][1]) }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_11') }			
		end
	end	
end
