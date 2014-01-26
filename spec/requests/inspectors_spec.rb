require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

describe "Inspectors:" do
	let!(:test_pa_path) { file_fixtures_directory+'addresses.csv' }
	# let!(:test_pk_path) { private_keys_file_path('csv',false) }
	subject { page }
	before do
	  visit inspect_path
	end
	it_should_behave_like 'the inspect page'
	describe "clicking the inspect button should display the csv in our html format" do
		let!(:data) { CSV.read(test_pa_path) }
		before do
		  attach_file "file", test_pa_path
		  click_button inspect_button
		end
		it_should_behave_like 'the addresses page'
		it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
		it { should have_selector('td.text_pubkey#address_10', text: data[10][1]) }
		it { should_not have_selector('td.text_pubkey#address_11') }
	end
end
