require 'spec_helper'

include FilesHelper
include CryptoHelper

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
		let!(:pk_unencrypted_path) { private_keys_file_path('csv',false) }
		let!(:pk_encrypted_path) { private_keys_file_path('csv',true) }
		subject { qm }
		it { should respond_to :keys }
		its(:keys) { should==keygen.keys }
		it { should respond_to :save_public_addresses }
		it { should respond_to :save_unencrypted_private_keys }
		describe "save_public_addresses" do
			it { expect{qm.save_public_addresses}.not_to raise_error }
			before { qm.save_public_addresses }
			describe "should save a csv file named addresses_list to the files/public folder" do				
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
			describe "should save the private kyes csv file to the files/PRIVATE/NON-ENCRYPTED folder" do	
				specify{File.exist?(pk_unencrypted_path).should be_true }
				describe "with a list of valid addresses" do
					let!(:data) { CSV.read(pk_unencrypted_path) }
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
		describe "save_encrypted_private_keys" do
			it { expect{qm.save_encrypted_private_keys}.to raise_error }
			it { expect{qm.save_encrypted_private_keys('foo')}.not_to raise_error }
			describe "should save an encrypted csv.aes file to the PRIVATE folder" do	
				before do
					delete_file(pk_encrypted_path)
				  qm.save_encrypted_private_keys('foo')
				end				
				specify{File.exist?(pk_encrypted_path).should be_true }
				describe "the file should be encrypted" do
					let!(:encrypted_data) { CSV.read(pk_encrypted_path) }
					let!(:decrypted_data) { JSON.parse decrypt(encrypted_data,'foo') }
					subject { decrypted_data }			
					# it { encrypted_data.should be_nil }		
					# it { decrypted_data.should be_nil }		
					it { encrypted_data.index(' ').should be_nil }
					it { encrypted_data.length.should > size+1 }
					describe "and when decrypted gives correct data" do						
						it { decrypted_data[0][0].should == '#' }
						it { decrypted_data[0][1].should == 'Bitcoin Address' }
						it { decrypted_data[0][2].should == 'Private Key' }
						it { decrypted_data[1][0].should == '1' }
						it { Bitcoin::valid_address?(decrypted_data[1][1]).should be_true}
						it { Bitcoin::Key.from_base58(decrypted_data[1][2]).addr.should == decrypted_data[1][1] }					
					end
				end	
			end
		end					
	end

end