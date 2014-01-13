require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FreezersHelper

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

describe "Ovens:" do
	subject { page }
	before do
	  visit root_path
	  click_link heatup_title
	end
	it_should_behave_like 'the heatup page'		
end
