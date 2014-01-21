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
				specify{File.exist?(path).should be_true }
				describe "with a list of valid addresses" do
					let!(:file) { CSV.read(path) }
					subject { file }
					its(:length) { should == size+1 }
					it { file[0][0].should == '#' }
					it { file[0][1].should == 'Bitcoin Address' }
					it { file[1][0].should == '1' }
					it { Bitcoin::valid_address?(file[1][1]).should be_true}
				end	
			end
		end
	end

end