require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FreezersHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Freezers Slow specs:", slow: true do
	subject { page }
	before do
	  visit root_path
	  click_link freeze_title
	end
	describe "submitting should redirect to private if a positive number is requested" do
		before do
		  fill_in 'howmany', with: '2'
		  click_button generate_button			  
		end
		it { should have_title cold_view_title }
	end
	describe "private page layout"  do
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button			  
		end		
		it_should_behave_like 'the cold_view page'		
	end
	describe "private page should show the correct number of addresses" do		
		before do
		  fill_in 'howmany', with: 2
		  click_button generate_button			  
		end
		it { should have_selector("td#address_1") }
		it { should have_selector("td#qr_address_2") }
		it { should have_selector("td#prvkey_wif_1") }
		it { should have_selector("td#qr_prvkey_wif_2") }
	end
	describe "submitting a user password should use that password" do
		before do
		  fill_in 'password', with: 'fooba'
		  fill_in 'howmany', with: 1
		  click_button generate_button
		end
		it { should have_title(cold_view_title) }		
		it { should have_selector('h2#show_password', text: ' encrypted with: [fooba]') }
		it { should have_selector('div.show_entropy', text: '10 bits' ) }
	end
	describe "not submitting a user password should encrypt with strong password" do
		before do
		  fill_in 'howmany', with: 1
		  click_button generate_button
		end
		it { should have_title(cold_view_title) }
		it { should_not have_selector('h2#show_password', text: ' encrypted with: []') }
		it { should have_selector('h2#show_password', text: ' encrypted with: [') }
	end
	describe "Cold Storgae Files are saved and are fresh" do
		let!(:plain_path) { coldstorage_directory+plaintext_file_name }
		let!(:encrypted_path) { coldstorage_directory+plaintext_file_name }
		before do
			fill_in 'howmany', with: 1		  
		  click_button generate_button		
		end
		specify{File.exist?(plain_path).should be_true }			
		specify{(File.ctime(plain_path).to_f-Time.now.to_f).to_i.should be < 1  }
		specify{File.exist?(encrypted_path).should be_true }
		specify{(File.ctime(encrypted_path).to_f-Time.now.to_f).to_i.should be < 1  }
	end
	describe ":ColdStorage Files:" do
		let!(:plain_path) { plaintext_file_path }
		let!(:encrypted_path) { encrypted_file_path }
		let!(:password) { 'arikstein' }
		before do
			fill_in 'howmany', with: 1		  
			fill_in 'password', with: password
		  click_button generate_button
		end
		describe "Plaintext file looks like the right HTML" do
			let!(:plain_file) { File.read(plain_path) }
			let!(:expected_prefix) { '<doctype></doctype><html><head><title>'+full_title(cold_view_title)+'</title>' }
			let!(:expected_pass) { '<h2 id="show_password">1 address encrypted with: [<div class="highlight_password">'+password+'</div>]' }
			it { page.should have_xpath("//div[@class='highlight_entropy'][@title='A brute force search for a word of length 9 in the alphabet [aeiknrst] requires ~ 2^26 trials, on average.']")}			
			specify {plain_file.index(expected_prefix).should == 0}
			specify {plain_file.index(expected_pass).should_not be_nil}
		end
		describe "Encrypted file is encrypted and can be decrypted with the right password" do
			let!(:encrypted_file) { File.read(encrypted_path) }
			let!(:plain_file) { File.read(plain_path) }
			let!(:expected_prefix) { '<doctype></doctype><html><head><title>'+full_title(cold_view_title)+'</title>' }
			let!(:expected_pass) { '<h2 id="show_password"> encrypted with: [<div class="highlight_password">'+password+'</div>]' }
			subject { encrypted_file }
			it { should_not be_blank }
			specify {encrypted_file.index(expected_prefix).should == nil}
			specify {AESCrypt.decrypt(encrypted_file,password).should == plain_file}
		end		
	end	
	describe ":ColdStorage Files with password cotaining spaces:" do
		let!(:plain_path) { plaintext_file_path }
		let!(:encrypted_path) { encrypted_file_path }
		let!(:password) { 'I like Mike $$ moSt of the Time' }
		before do
			fill_in 'howmany', with: 1		  
			fill_in 'password', with: password
		  click_button generate_button
		end
		describe "Encrypted file is encrypted and can be decrypted with the right password" do
			let!(:encrypted_file) { File.read(encrypted_path) }
			let!(:plain_file) { File.read(plain_path) }
			let!(:expected_prefix) { '<doctype></doctype><html><head><title>'+full_title(cold_view_title)+'</title>' }
			let!(:expected_pass) { '<h2 id="show_password"> encrypted with: [ <div class="highlight_password">'+password+'</div> ]' }
			subject { encrypted_file }
			it { should_not be_blank }
			specify {encrypted_file.index(expected_prefix).should == nil}
			specify {AESCrypt.decrypt(encrypted_file,password).should == plain_file}
		end		
	end	
end
