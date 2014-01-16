shared_examples_for "all pages" do 
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	# it { should have_selector('footer.footer') }
	it { should have_link(app_title, href: root_path) }	
	it { should have_link('navbar_freeze', href: freeze_path) }	
	it { should have_link('navbar_heatup', href: heatup_path) }
	it { should have_link('About', href: about_path) }
	it { should have_link('Help', href: help_path) }
end	

shared_examples_for "the freeze page" do
	it { should have_title full_title(freeze_title) }
	it { should have_selector('input#howmany') }
	it { should have_xpath("//input[@value=0]")}
	it { should have_button generate_button}
	it { should have_selector('input#password.input-xxlarge') }
end

shared_examples_for "a view page" do
	it { should have_selector('h2#show_password', text: ' encrypted with: [') }
	it { should have_selector('th', text: 'Bitcoin Address') }		
	it { should have_selector('th', text: 'Private Key') }		
	it { should have_selector('table.private_output#private_output') }		
	it { should have_selector("td#address_1") }
	it { should have_selector("td#qr_address_1") }
	it { should have_selector("td#prvkey_wif_1") }
	it { should have_selector("td#qr_prvkey_wif_1") }	
end

shared_examples_for "the heatup page" do
	it { should have_title full_title(heatup_title) }
	it { should have_selector('input#recover_password.input-xxlarge') }
	it { should have_selector('input#recover_button') }
end

shared_examples_for "it failed decryption" do
	it { should_not have_content('Bitcoin Address') }
	it { should_not have_content('Private Key') }
	it { should_not have_selector('div.normal', text: '(Wallet Import Format)') }
	it { should_not have_selector("td#address_1") }
	it { should_not have_selector("td#prvkey_wif_1") }
	it { should have_selector('div.alert.alert-error', text: failed_decryption_message) }
end
