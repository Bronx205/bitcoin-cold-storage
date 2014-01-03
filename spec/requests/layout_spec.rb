require 'spec_helper'
require 'shared_examples'
include ViewsHelper


describe "layout" do
	subject { page }
	describe "home page" do
		before { visit root_path }
		it_should_behave_like 'all pages'
	end
	describe "private page" do
		before { visit private_path }
		it_should_behave_like 'all pages'
	end
	describe "public page" do
		before { visit public_path }
		it_should_behave_like 'all pages'
	end		
end