require 'spec_helper'

describe "quartermaster" do
	let!(:qm) { Quartermaster.new }
	subject { qm }
	describe "attributes" do
		it { should respond_to :unencrypted_html }
		it { should respond_to :unencrypted_text }
	end
end