require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Freezers:" do
	subject { page }
	before do
	  visit freeze_path
	end
	it_should_behave_like 'the freeze page'
	describe "submitting should stay on freeze page if the request was not a positive number is requested" do
		['',0,-5,'foo',nil].each do |example|
			before do
			  fill_in 'howmany', with: example
			  click_button generate_button			  
			end
			it_should_behave_like 'the freeze page'			
		end
	end
	describe "must requrest a positive number between 1 and limit, otherwise, flash error and stay on freeze_path" do
		before do
		  fill_in 'howmany', with: KEYS_LIMIT+1
		  click_button generate_button
		end
		it { should have_title freeze_page_title }
		it { should have_selector('div.alert.alert-error', text: addresses_range_notice) }
		it_should_behave_like "flash should go away"
	end
	describe "SSSS params should make sense, otherwise, flash error and stay on freeze_path" do
		describe "negative n" do
			before do
			  fill_in 'howmany', with: 1
			  fill_in 'ssss_n', with: -1
			  click_button generate_button
			end
			it { should have_title freeze_page_title }
			it { should have_selector('div.alert.alert-error', text: /#{at_least_two_shares_flash}/) }
			it_should_behave_like "flash should go away"			
		end
		describe "non numberic n" do
			before do
			  fill_in 'howmany', with: 1
			  fill_in 'ssss_n', with: 'foo'
			  click_button generate_button
			end
			it { should have_title freeze_page_title }
			it { should have_selector('div.alert.alert-error', text: at_least_two_shares_flash) }
			it_should_behave_like "flash should go away"			
		end
		describe "negative k" do
			before do
			  fill_in 'howmany', with: 1
			  fill_in 'ssss_k', with: -1
			  click_button generate_button
			end
			it { should have_title freeze_page_title }
			it { should have_selector('div.alert.alert-error', text: at_least_two_shares_flash) }
			it_should_behave_like "flash should go away"			
		end
		describe "non numberic k" do
			before do
			  fill_in 'howmany', with: 1
			  fill_in 'ssss_k', with: 'foo'
			  click_button generate_button
			end
			it { should have_title freeze_page_title }
			it { should have_selector('div.alert.alert-error', text: at_least_two_shares_flash) }
			it_should_behave_like "flash should go away"			
		end
		describe "k not smaller than n" do
			before do
			  fill_in 'howmany', with: 1
			  fill_in 'ssss_n', with: 3
			  fill_in 'ssss_k', with: 3
			  click_button generate_button
			end
			it { should have_title freeze_page_title }
			it { should have_selector('div.alert.alert-error', text: k_not_smaller_than_n_flash) }
			it_should_behave_like "flash should go away"			
		end	
		describe "k not smaller than n" do
			before do
			  fill_in 'howmany', with: 1
			  fill_in 'ssss_n', with: 3
			  fill_in 'ssss_k', with: 1
			  click_button generate_button
			end
			it { should have_title freeze_page_title }
			it { should have_selector('div.alert.alert-error', text: at_least_two_shares_flash) }
			it_should_behave_like "flash should go away"			
		end														
	end	
	# describe "visiting the addresses path without an addresses.csv file should flash error and redirect home" do
	# 	before { visit new_keys_path }
	# 	it { should have_title home_title }
	# end	

end
