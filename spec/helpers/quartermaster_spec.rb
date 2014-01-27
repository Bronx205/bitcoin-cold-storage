require 'spec_helper'

include FilesHelper

describe "quartermaster" do

	describe "init" do
		it {expect {Quartermaster.new([1])}.to raise_error(RuntimeError, 'Invalid keys')}
		it {expect {Quartermaster.new([])}.to raise_error(RuntimeError, 'Invalid keys')}
		it {expect {Quartermaster.new}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1)')}
	end
	describe "quartermaster" do
		let!(:keygen) { KeyGenerator.new(2) }
		let!(:size) { keygen.howmany }
		let!(:qm) { Quartermaster.new(keygen.keys) }
		let!(:pa_path) { public_addresses_file_path('csv') }
		let!(:pk_path) { private_keys_file_path('csv',false) }
		subject { qm }
		it { should respond_to :keys }
		its(:keys) { should==keygen.keys }
		it { should respond_to :save_public_addresses }
		it { should respond_to :save_unencrypted_private_keys }
		describe "save_public_addresses" do
			it { expect{qm.save_public_addresses}.not_to raise_error }
			before { qm.save_public_addresses }
			describe "should save a csv file named addresses_list to a public folder under the files dir" do				
				specify{File.exist?(pa_path).should be_true }
				describe "with a list of valid addresses" do
					let!(:data) { CSV.read(pa_path) }
					subject { data }
					its(:length) { should == size+1 }
					it { data[0][0].should == '#' }
					it { data[0][1].should == 'Bitcoin Address' }
					it { data[1][0].should == '1' }
					it { Bitcoin::valid_address?(data[1][1]).should be_true}
				end	
			end
		end
		describe "save_unencrypted_private_keys" do
			it { expect{qm.save_unencrypted_private_keys}.not_to raise_error }
			before { qm.save_unencrypted_private_keys }
			describe "should save the csv file to a public folder under the files dir" do	
				specify{File.exist?(pk_path).should be_true }
				describe "with a list of valid addresses" do
					let!(:data) { CSV.read(pk_path) }
					subject { data }
					its(:length) { should == size+1 }
					it { data[0][0].should == '#' }
					it { data[0][1].should == 'Bitcoin Address' }
					it { data[0][2].should == 'Private Key' }
					it { data[1][0].should == '1' }
					it { Bitcoin::valid_address?(data[1][1]).should be_true}
					it { Bitcoin::Key.from_base58(data[1][2]).addr.should == data[1][1] }
				end	
			end
		end		
	end

end