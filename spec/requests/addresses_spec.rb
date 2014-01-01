require 'spec_helper'
include ViewsHelper

describe "Addresses" do
	subject { page }
	describe "private page" do
		before { visit private_path }
		it { should have_title full_title(private_title) }
		it { should have_content 'Bitcoin Address' }
		it { should have_selector('div.qrcode') }
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
	end
end
