require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Freezers Slow specs:" do
	subject { page }
	before do
	  visit freeze_path
	end
	describe "submitting should redirect to view if a positive number is requested"  do
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button	
		end		
		it_should_behave_like 'the private keys page'		
		it { should have_selector('div.alert.alert-password') }
		it { should have_title full_title(private_keys_title) }
	end

end
