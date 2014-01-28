require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Static" do
	subject { page }

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like 'all pages'   
    it { should have_title full_title(home_title) }
    it { should have_selector('div#catchy', text: catch_phrase) }
    it { should have_selector('div#elevator', text: elevator_pitch) }
    it { should have_xpath("//a[@class='btn btn-primary'][@title='#{freeze_button_title}'][@id='big_freeze_button']")}
    it { should have_xpath("//a[@class='btn btn-danger'][@title='#{inspect_button_title}'][@id='big_inspect_button']")}    
    describe "big freeze button takes you to the freeze page" do
      before { find('#big_freeze_button',visible: true).click}
      it { should have_title(freeze_page_title) }
    end
    describe "big inspect button should take you to the inspect page" do
      before { find('#big_inspect_button',visible: true).click }
      it { should have_title(inspect_page_title) } 
    end
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