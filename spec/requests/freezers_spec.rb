require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FreezersHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Freezers:" do
	subject { page }
	before do
	  visit root_path
	  click_link freeze_title
	end
	it_should_behave_like 'the freeze page'
	it { should have_xpath("//input[@value=0]")}
	describe "submitting should stay on setup if the request was not a positive number is requested" do
		['',0,-5,'foo',nil].each do |example|
			before do
			  fill_in 'howmany', with: example
			  click_button generate_button			  
			end
			it_should_behave_like 'the freeze page'			
		end
	end
	describe "navigating directly to the cold_view page should redirect to setup" do
		before { visit cold_view_path }
		it { should have_title(home_title) }
	end	
	describe "directly visiting the view path should redirect home" do
		before { visit cold_view_path }
		it { should have_title home_title }
	end		
end
