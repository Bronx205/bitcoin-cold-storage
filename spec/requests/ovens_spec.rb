require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FreezersHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Ovens:" do
	subject { page }
	describe "layout" do
		before do
		  visit root_path
		  click_link heatup_title
		end
		it_should_behave_like 'the heatup page'			
	end
	describe "should recover a cold storage file with a valid password", slow: true do
		before do
		  visit root_path
		  click_link freeze_title
		  fill_in 'howmany', with: 2
		  fill_in 'password', with: 'foo'
		  click_button generate_button
		  sleep 1.second
		  click_link heatup_title
		  fill_in 'recover_password', with: 'foo'
		  click_button recover_button
		end
		it { should have_content('Bitcoin Address') }
		it { should have_content('Private Key') }
		it { should have_selector('div.normal', text: '(Wallet Import Format)') }
		it { should have_selector("td#address_1") }
		it { should have_selector("td#qr_address_2") }
		it { should have_selector("td#prvkey_wif_1") }
		it { should have_selector("td#qr_prvkey_wif_2") }	
	end

end
