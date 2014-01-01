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
		it { should have_selector('input#howmany_button') }
	end
end
