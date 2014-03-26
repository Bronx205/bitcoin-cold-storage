require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include PathHelper
include FilesHelper

describe "Freezers" do	
	subject { page }
	before do
		nuke_coldstorage_directory
	  visit freeze_path
	end
	describe "submitting should redirect to view if a positive number is requested"  do
		before do
			fill_in 'howmany', 	with: 2		
			fill_in 'password', with: 'supercali'  
		  click_button generate_button
		end
		it { $tag[0..5].should == '_test_' }		
		it_should_behave_like 'it saved the files'
		it_should_behave_like 'the private keys page'
		it { should_not have_selector('td.black')}
		it_should_behave_like 'it has download buttons'
		# it { should have_selector('div.alert.alert-password', text: 'supercali') }
		it { should have_selector('div#show_password', text: 'supercali') }
		describe "and should show the correct number of rows" do
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }	
		end
		describe "clicking the first addresse QR link should generate the QR" do
			before { click_link 'address_qr_btn_1' }
			it { should have_selector('td.black') }
		end
		describe "clicking the first private keys QR link should generate the QR" do
			before { click_link 'prvkey_qr_btn_1' }
			it { should have_selector('td.black') }
		end						
	end
	describe "submitting without password should default to a strong password"  do
		before do
			fill_in 'howmany', 	with: 1
		  click_button generate_button			  
		end		
		it_should_behave_like 'the private keys page'	
		it_should_behave_like 'it has download buttons'	
		describe "the number of share links should be #{DEFAULT_SSSN} (default)" do
			it { should have_link "password_share_#{DEFAULT_SSSN}"}  
		end
		# it { should have_selector('div.alert.alert-password', text: 'randomly generated') }			
		it { should have_selector('div#password_message', text: 'randomly generated') }
	end
	describe "views" do
		before do
			fill_in 'howmany', 	with: 2		
			fill_in 'password', with: 'moooohaha' 
			fill_in 'ssss_n', 	with: '3' 
			fill_in 'ssss_k', 	with: '2' 
		  click_button generate_button	
		end
		describe "private keys view" do
			describe "should show in HTML the content of private_keys.csv" do
				let!(:data) { CSV.read(private_keys_file_path('csv',false)) }
				before { visit new_keys_path }
				it_should_behave_like 'the private keys page'
				it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
				it { should have_selector('td.text_prvkey#prvkey_wif_1', text: data[1][2]) }
				describe "and redirect home if there is no such file" do
					before do
					  clear_coldstorage_files
					  visit new_keys_path
					end
					it { should have_title(home_title) }
				end				
			end
			describe "download UNencrypted button should" do
				describe "save the file to the usb location" do
					before do
					  clear_coldstorage_files(true)
					  click_link save_non_encrypted_button
					end					
					specify{File.exist?(unencrypted_directory_path(true)+private_keys_file_name+'.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files(false)
					  click_link save_non_encrypted_button
					end
					it { should have_title(home_title) }				
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }						
				end			
			end
			describe "download encrypted link should" do
				describe "save the file to the usb location" do
					before do
					  clear_coldstorage_files(true)
					  click_link download_encrypted_link
					end					
					specify{File.exist?(encrypted_directory_path(true)+private_keys_file_name+'.csv.aes').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files(false)
					  click_link download_encrypted_link
					end
					it { should have_title(home_title) }				
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }						
				end			
			end
			describe "download shares link should" do
				describe "save the file to the usb location" do
					before do
					  clear_coldstorage_files(true)
					  click_link 'password_share_1'
					end					
					specify{File.exist?(encrypted_directory_path(true)+password_share_file_name+'.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files(false)
					  click_link 'password_share_1'
					end
					it { should have_title(home_title) }				
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }						
				end			
			end											
			describe "the number of share links should be 3" do
				it { should have_link 'password_share_3'}  
				it { should_not have_link 'password_share_4'}  
				describe "as is the number of shares files" do
					3.times do |n|
						specify{File.exist?(password_shares_path(n+1)).should be_true }	
					end						
					specify{File.exist?(password_shares_path(4)).should be_false }						
				end
			end						
		end
		describe "addresses view" do
			describe "should show in HTML the content of addresses.csv" do
				let!(:data) { CSV.read(public_addresses_file_path('csv')) }
				before { visit new_addresses_path }
				it_should_behave_like 'the addresses page'
				it { should_not have_selector('td.black')}
				it { should have_selector('td.text_pubkey#address_1', text: data[1][1]) }
				describe "clicking the first addresse QR link should generate the QR" do
					before { click_link 'address_qr_btn_1' }
					it { should have_selector('td.black') }
				end				
				describe "and redirect home if there is no such file" do
					before do
					  clear_coldstorage_files
					  visit new_addresses_path
					end
					it { should have_title(home_title) }
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }
				end
			end
			describe "save addresses button should" do
				describe "save the files to the usb location" do
					before do
					  clear_coldstorage_files(true)
					  click_link download_addresses_button
					end					
					specify{File.exist?(public_directory_path(true)+public_addresses_file_name+'.csv').should be_true }
				end
				describe "and redirect home if no file" do
					before do
					  clear_coldstorage_files
					  click_link download_addresses_button
					end
					it { should have_title(home_title) }				
					it { should have_selector('div.alert.alert-error', text: missing_file_error) }						
				end			
			end
		end
	end
	describe "should not die on a big dispatch" do
		before do
			fill_in 'howmany', with: 10		  
		  click_button generate_button		  	  
		end		
		it_should_behave_like 'the private keys page'	
		it_should_behave_like 'it has download buttons'
	end
	after(:all) do
		nuke_coldstorage_directory
	end

end
