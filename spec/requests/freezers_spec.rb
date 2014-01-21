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
	describe "limit to addresses limit, flash error and stay on freeze_path" do
	let!(:keys_limit) { ColdStorage.new.keys_limit }		
		before do
		  fill_in 'howmany', with: keys_limit+1
		  click_button generate_button
		end
		it { should have_title freeze_title }
		it { should have_selector('div.alert.alert-error', text: addresses_range_notice) }
		it_should_behave_like "flash should go away"
	end
	describe "directly visiting the view path should redirect home" do
		before { visit cold_view_path }
		it { should have_title home_title }
	end		
end
