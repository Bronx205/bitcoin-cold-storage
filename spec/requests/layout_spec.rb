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
	describe "freeze link should show freeze page" do
		before { click_link freeze_title }
		it { should have_title setup_title }
	end
	describe "heatup link should show heatup page" do
		before { click_link heat_title }
		it { should have_title heat_title }
	end		
end