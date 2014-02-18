# require 'spec_helper'
# require 'shared_examples'

# include ViewsHelper
# include FilesHelper

# describe "Ovens:", disabled: true do
# 	subject { page }
# 	before do
# 	  visit root_path
# 	  find('#navbar_freeze',:visible => true).click 
# 	  fill_in 'howmany', with: 1
# 	  fill_in 'password', with: 'foo'
# 	  click_button generate_button
# 	  click_link heatup_title
# 	end	
# 	describe "should recover a cold storage file with a valid password" do
# 		before do
# 		  fill_in 'recover_password', with: 'foo'
# 		  click_button recover_button
# 		end
# 		it_should_behave_like "the private keys page"
# 	end
# 	describe "should fail gracefully when attempting to heat up with wrong password" do
# 		before do
# 		  fill_in 'recover_password', with: rand.to_s.split('.').join
# 		  click_button recover_button
# 		end
# 		it_should_behave_like "it failed decryption"
# 		it { should have_button recover_button }
# 		it_should_behave_like "flash should go away"
# 	end
# 	describe "heatup link should redirect home and flash error if file not there" do
# 		before do
# 		  delete_file(private_keys_file_path('html',true))
# 		  visit root_path
# 		  find('#navbar_inspect',:visible => true).click 
# 		end
# 		it { should have_title home_title}
# 		it { should have_selector('div.alert.alert-error', text: no_file_message) }
# 	end
# end
