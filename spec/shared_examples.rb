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
	it { should have_xpath("//input[@value=1]")}
end