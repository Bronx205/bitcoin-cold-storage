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
		  visit heatup_path
		end
		it_should_behave_like 'the heatup page'			
	end
	describe "should recover a cold storage file with a valid password", slow: true do
		before do
		  visit root_path
		  find('#navbar_freeze',:visible => true).click 
		  fill_in 'howmany', with: 2
		  fill_in 'password', with: 'foo'
		  click_button generate_button
		  sleep 2.second
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
	describe "should fail gracefully when attempting to heat up with wrong password", slow: true do
		before do
		  visit root_path
		  find('#navbar_heatup',:visible => true).click 
		  fill_in 'recover_password', with: rand.to_s.split('.').join
		  click_button recover_button
		end
		it_should_behave_like "it failed decryption"
		describe "flash should go away" do
			describe "when navigating home" do
				before { click_link app_title }
				it { should_not have_selector('div.alert')}
			end
			describe "when navigating to Help" do
				before { click_link 'Help' }
				it { should_not have_selector('div.alert')}
			end
			describe "when navigating to About" do
				before { click_link 'About' }
				it { should_not have_selector('div.alert')}
			end						
			describe "when navigating to freeze page" do
				before { click_link freeze_title }
				it { should_not have_selector('div.alert')}
			end		
			describe "when reloading heatup page" do
				before { click_link heatup_title }
				it { should_not have_selector('div.alert')}
			end					
		end
	end
	describe "should fall gracefully if the file is not there" do
		before do
		  delete_file(encrypted_file_path)
		  visit root_path
		  find('#navbar_heatup',:visible => true).click 
		end
		it { should_not have_button(recover_button) }
	end	
	# describe "should fall gracefully if the file is not there" do
	# 	before do
	# 	  delete_file(encrypted_file_path)
	# 	  visit root_path
	# 	  find('#navbar_heatup',:visible => true).click 
	# 	  click_button recover_button
	# 	end
	# 	it_should_behave_like "it failed decryption"
	# end
end
