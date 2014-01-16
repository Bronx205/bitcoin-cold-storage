require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FreezersHelper

describe "Ovens:", slow: true do
	subject { page }
	before do
	  visit root_path
	  find('#navbar_freeze',:visible => true).click 
	  fill_in 'howmany', with: 1
	  fill_in 'password', with: 'foo'
	  click_button generate_button
	  click_link heatup_title
	end	
	describe "should recover a cold storage file with a valid password" do
		before do
		  fill_in 'recover_password', with: 'foo'
		  click_button recover_button
		end
		it_should_behave_like "a view page"
	end
	describe "should fail gracefully when attempting to heat up with wrong password" do
		before do
		  fill_in 'recover_password', with: rand.to_s.split('.').join
		  click_button recover_button
		end
		it_should_behave_like "it failed decryption"
		it { should have_button recover_button }
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
		  delete_file(plaintext_file_path)
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
