require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

describe "Inspectors:" do
	subject { page }
	before do
	  visit inspect_path
	end
	it_should_behave_like 'the inspect page'
	describe "clicking the inspect button should display the csv in our html format" do
		before do
		  attach_file "file", public_addresses_file_path('csv')
		  click_button inspect_button
		end
		it_should_behave_like 'the addresses page'
	end
end
