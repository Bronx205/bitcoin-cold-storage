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
	

	# describe "save_csv" do


	# 	describe "can load the file:" do
	# 		let!(:loaded) { load_encrypted(path) }
	# 		subject { loaded }
	# 		it { should_not be_blank }
	# 		describe "and the file can be encrypted:" do
	# 			specify{decrypt_my_file(loaded,'bar').should == html}
	# 			specify{decrypt_loaded(path,'bar').should == html}
	# 		end			
	# 	end
	# 	after do
	# 		delete_file(path)
	# 	end
	# end

end