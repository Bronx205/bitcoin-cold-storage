require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include FilesHelper

describe "Inspectors:" do
	subject { page }
	before do
	  visit inspect_path
	end
	it_should_behave_like 'the inspect page'
end
