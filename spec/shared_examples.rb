shared_examples_for "all pages" do 
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_selector('footer.footer') }
	it { should have_link(app_title, href: root_path) }	
	it { should have_link(private_title, href: private_path) }
  it { should have_link(public_title, href: public_path) }		  
end	

shared_examples_for "default_setup" do
	it { should have_title full_title(setup_title) }
	it { should have_button howmany_button_title}
	it { should have_selector('input#howmany') }	
end

shared_examples_for "the private page" do
	it { should have_title full_title(private_title) }
	it { should have_link 'download html'}
	it { should have_link 'download encrypted' }	
	it { should have_selector('th', text: 'Bitcoin Address') }		
	it { should have_selector('th', text: 'Private Key') }		
	it { should have_selector('table.private_output#private_output') }		
end