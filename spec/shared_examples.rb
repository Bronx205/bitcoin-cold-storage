shared_examples_for "all pages" do 
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_selector('footer.footer') }
	it { should have_link(app_title, href: root_path) }	
	it { should have_link(freeze_title, href: freeze_path) }	
	# it { should have_selector('ul.dropdown-menu li a', text: setup_title) }
	# it { should have_selector('ul.dropdown-menu li a', text: view_title) }
	it { should have_link(heatup_title, href: heatup_path) }
end	

shared_examples_for "the freeze page" do
	it { should have_title full_title(setup_title) }
	it { should have_selector('input#howmany') }
	it { should have_button generate_button}
	it { should have_selector('input#password.input-xxlarge') }
end

shared_examples_for "the cold_view page" do
	it { should have_title full_title(view_title) }
	it { should have_selector('h2#show_password', text: ' encrypted with: [') }
	it { should have_selector('th', text: 'Bitcoin Address') }		
	it { should have_selector('th', text: 'Private Key') }		
	it { should have_selector('table.private_output#private_output') }		
end