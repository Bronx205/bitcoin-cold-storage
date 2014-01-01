require 'spec_helper'
include ViewsHelper

describe "Addresses" do
	subject { page }
	describe "private page" do
		before { visit private_path }
		it { should have_title full_title(private_title) }
		it { should have_selector('th', text: 'Bitcoin Address') }
		it { should have_selector('div.qrcode') }
		it { should have_selector('table.private_output#private_output') }
	end

	describe "setup page" do
		before { visit root_path }
		it { should have_title full_title(setup_title) }
		it { should have_button howmany_button_title}
		it { should have_selector('input#howmany') }
		describe "submitting should redirect to private" do
			before do
			  fill_in 'howmany', with: '123'
			  click_button howmany_button_title			  
			end
			it { should have_title private_title }
			describe "cookie persistance of howmany" do
				before { visit root_path }
				it { find_field('howmany').value.should == '123' }
				it { find_field('howmany').value.should_not == '124' }
			end
		end
		describe "private page should show the correct number of addresses" do
			before do
			  fill_in 'howmany', with: '3'
			  click_button howmany_button_title			  
			end			
			(1..3).each do |x|
				it { should have_selector("tr#row_#{x}") }
				# it { should have_selector("div.qrcode##{x}") }
			end
		end
	end
end
