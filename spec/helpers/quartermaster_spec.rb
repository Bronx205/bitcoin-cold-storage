require 'spec_helper'

include FilesHelper
include CryptoHelper

describe "quartermaster" do

	describe "init" do
		it {expect {Quartermaster.new([1])}.to raise_error(ArgumentError, 'wrong number of arguments (1 for 3..4)')}
		it {expect {Quartermaster.new}.to raise_error(ArgumentError, 'wrong number of arguments (0 for 3..4)')}		
		it {expect {Quartermaster.new([1],'a',{n:3, k:2}) }.to raise_error(RuntimeError, 'Invalid keys')}
		it {expect {Quartermaster.new([],'b',{n:3, k:2}) }.to raise_error(RuntimeError, 'Invalid keys')}
	end
	describe "quartermaster" do
		let!(:keygen) { KeyGenerator.new(2) }
		let!(:size) { keygen.howmany }
		let!(:pass) { "I love yoO $$ a Bu$hel!! \n and \t peck...." }			
		let!(:qm) { Quartermaster.new(keygen.keys,pass,{n:3, k:2}) }
		let!(:pa_path) { public_addresses_file_path('csv') }
		let!(:pk_unencrypted_path) { private_keys_file_path('csv',false) }
		let!(:pk_encrypted_path) { private_keys_file_path('csv',true) }
		subject { qm }
		it { should respond_to :keys }
		it { should respond_to :password }
		it { should respond_to :tag }
		its(:keys) { should==keygen.keys }
		its(:password) { should==pass }
		its(:tag) { should be_blank }
		it { should respond_to :save_public_addresses }
		it { should respond_to :save_unencrypted_private_keys }
		describe "cleanup of old files" do
			it { old_coldstorage_files?.should be_false }
		end		
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
			it { expect{qm.save_encrypted_private_keys}.not_to raise_error }
			describe "should save an encrypted csv.aes file to the PRIVATE folder" do	
				before do
					delete_file(pk_encrypted_path)
				  qm.save_encrypted_private_keys
				end				
				specify{File.exist?(pk_encrypted_path).should be_true }
				describe "the file should be encrypted" do
					let!(:encrypted_data) { File.read(pk_encrypted_path) }
					let!(:decrypted_data) { JSON.parse decrypt(encrypted_data,pass) }					
					subject { decrypted_data }			
					it { should be_an_instance_of Array }
					it { encrypted_data.should be_an_instance_of String }
					it { expect{decrypt(encrypted_data,'bar')}.to raise_error }
					it { expect{decrypt(encrypted_data[1..-1],'foo')}.to raise_error }
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
		describe "save_password_shares" do						
			it { expect{qm.save_password_shares}.not_to raise_error }
			describe "should save a csv file to the PRIVATE folder" do	
				before do
					clear_coldstorage_files
				  qm.save_password_shares
				end
				3.times do |n|
					specify{File.exist?(password_shares_path(n+1)).should be_true }	
				end				
				describe "with a list of password shares" do
					let!(:ps) { PasswordSplitter.new(3,2) }
					3.times do |n|
						let!("share#{n+1}") { CSV.read(password_shares_path(n+1)) }	
					end
					it { share1[0][0].should == 'Password Share' }
					it { share1[0][1].should be_nil }
					it { share1[1][0].should_not be_blank }
					it { PasswordJoiner.new([share1[1][0],share2[1][0]]).password.should == pass  }
					it { share2[0][0].should == 'Password Share' }
					it { share2[0][1].should be_nil }
					it { share2[1][0].should_not be_blank }
					it { PasswordJoiner.new([share2[1][0],share3[1][0]]).password.should == pass  }
					it { share3[0][0].should == 'Password Share' }
					it { share3[0][1].should be_nil }
					it { share3[1][0].should_not be_blank }
					it { PasswordJoiner.new([share3[1][0],share1[1][0]]).password.should == pass  }									
				end	
			end
		end							
	end
end

