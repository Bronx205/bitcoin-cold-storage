require 'spec_helper'

describe ViewsHelper do

	describe "inject CSS:" do
		let!(:css) { 'foo' }
		let!(:bare_html) { '<html><head><title></title></head><body></body></html>' }
		let!(:full_html) { '<html><head><title></title></head><body></body><style type="text/css">'+css+'</style></html>' }
		specify {inject_css(bare_html,css).should == full_html}
	end

	describe "trim CSS:" do
		let!(:bare_html) { '<html><head><title></title></head><body></body></html>' }
		let!(:full_html) { '<html><head><title></title></head><body></body><style type="text/css">foo</style></html>' }
		specify {trim_css(full_html).should == bare_html}
		specify {trim_css('foobar').should == 'foobar'}
		specify {trim_css('').should == ''}
		specify	{trim_css(nil).should == ''}
	end

	describe "extract relevant html" do
		let!(:full_html) { '<foo></foo><div class="heatup_begin">contentblah<div class="heatup_end"><bar></bar>' }
		let!(:trimmed) { 'contentblah' }
		specify {extract_addresses_html(full_html).should == trimmed}
		specify {extract_addresses_html('foobar').should == 'foobar'}
		specify {extract_addresses_html('').should == ''}
		specify	{extract_addresses_html(nil).should == ''}
	end

end