require 'spec_helper'

describe FilesHelper do
	let!(:header) { ['c1','c2'] }
	let!(:data) { [['11','12'],['21','22']] }
	let!(:path) { coldstorage_directory + 'csvtest.csv' }
	let!(:epath) { coldstorage_directory + 'ecsvtest.csv' }
	it {expect {save_csv(path,header,data)}.not_to raise_error}
	it {expect {save_enum_csv(epath,header,data)}.not_to raise_error}

	describe "save_csv" do
		before do
			save_csv(path,header,data)
		end
		describe "csv file should be correct" do
			let!(:file) { CSV.read(path) }
			subject { file }
			it { should ==  [["c1", "c2"], ["11", "12"], ["21", "22"]] }
		end
		after do
			delete_file(path)
		end
	end
	describe "save_enum_csv" do
		before do
			save_enum_csv(epath,header,data)
		end
		describe "csv file should be correct" do
			let!(:efile) { CSV.read(epath) }
			subject { efile }
			it { should ==  [["#","c1", "c2"], ["1","11", "12"], ["2","21", "22"]] }
		end
		after do
			delete_file(epath)
		end
	end

	describe "path selection" do
		it "should choose the right path for unencrypted" do
			private_keys_file_path('foo',false).should ==unencrypted_directory_path + private_keys_file_name + '.foo'
		end
		it "should choose the right path for encrypted" do
			private_keys_file_path('foo').should ==encrypted_directory_path + private_keys_file_name + '.foo'
		end		
	end

end