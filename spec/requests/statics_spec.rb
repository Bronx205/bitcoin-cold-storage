require 'spec_helper'
require 'shared_examples'
include ViewsHelper

describe "Static" do
	subject { page }

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like 'all pages'   
    it { should have_title full_title(home_title) }
  end 

  describe "Help page" do
    before { visit help_path }
    let(:page_title) {'Help'}
    it_should_behave_like "all pages"
    it { should have_title full_title("Help") }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_title full_title("About") }
    it_should_behave_like "all pages"
  end

end