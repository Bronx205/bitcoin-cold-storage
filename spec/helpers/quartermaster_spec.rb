require 'spec_helper'

describe "quartermaster" do
	let!(:qm) { Quartermaster.new }
	subject { qm }
	describe "attributes" do
		it { should respond_to :save_public_bulk }
		it { should respond_to :save_private_bulk }
	end
end