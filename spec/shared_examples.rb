shared_examples_for "all pages" do 
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_selector('footer.footer') }
	it { should have_link(app_title, href: root_path) }	
	it { should have_link(private_title, href: private_path) }
  it { should have_link(public_title, href: public_path) }		  
end	