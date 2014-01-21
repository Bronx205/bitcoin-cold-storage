require 'spec_helper'

include FilesHelper

describe "quartermaster" do

	describe "init" do
		it {expect {Quartermaster.new([1])}.to raise_error(RuntimeError, 'Invalid keys')}
		it {expect {Quartermaster.new([])}.to raise_error(RuntimeError, 'Invalid keys')}
		it {expect {Quartermaster.new}.to raise_error(RuntimeError, 'Invalid keys')}
	end
	describe "quartermaster" do
		let!(:keygen) { KeyGenerator.new(2) }
		let!(:size) { keygen.howmany }
		let!(:qm) { Quartermaster.new(keygen.keys) }
		let!(:path) { public_addresses_file_path }
		subject { qm }
		it { should respond_to :keys }
		its(:keys) { should==keygen.keys }
		it { should respond_to :save_public_addresses }
		describe "save_public_addresses" do
			it { expect{qm.save_public_addresses}.not_to raise_error }
			before { qm.save_public_addresses }
			describe "should save a csv file named addresses_list to a public folder under the files dir" do				

			end
		end
	end

end