require 'spec_helper'
require 'shared_examples'
include ViewsHelper


describe "layout" do
	before { visit root_path }
	subject { page }
	describe "home page" do
		before { click_link app_title}
		it_should_behave_like 'all pages'
		it { should have_title home_title }
	end
	describe "view cold page should redirect home" do
		before { click_link view_title }
		it { should have_title home_title }
	end
	describe "setup cold page" do
		before { click_link setup_title }
		it { should have_title setup_title }
	end		
end