require 'spec_helper'

describe "password splitter" do
	# it { PasswordSplitter.should respond_to :join }
	let!(:splitter) { PasswordSplitter.new }
	subject { splitter }
	describe "attributes" do
		it { should respond_to :password }
		it { should respond_to :shares }
		it { should respond_to :k }
		it { should respond_to :n }
		it { should respond_to :join }
	end

	describe "default initializer" do
		its(:password) { should_not be_blank }
		its(:k) { should == 3 }
		its(:n) { should == 5 }
		its(:shares) { should_not be_nil }
		its(:shares) { should be_an_instance_of Array }
	end

	describe "initializer with a password" do
		let!(:splitter_with_pass) { PasswordSplitter.new(3,2,'foobar') }
		subject { splitter_with_pass }
		describe "should have the right attributes" do
			its(:password) { should == 'foobar' }
			its(:k) { should == 2 }
			it {splitter_with_pass.shares.length.should == 3}
		end
	end

	describe "k bigger than n" do
		it { expect{PasswordSplitter.new(3,4)}.to raise_error(ArgumentError, 'k must be smaller or equal than n') }
	end

	describe "join" do
		describe "random password" do
			let(:empty) { PasswordSplitter.new }
			let!(:pg) { PasswordSplitter.new(3,2) }		
			let!(:pg_shares) { pg.shares.drop(1).join("\n") }
			it "should raise error if not enough shares" do
				expect {pg.join(2,'123')}.to raise_error('Not enough shares')
			end	
			it "should retrieve the password" do
				pg.join(2,pg_shares).should == pg.password	
				empty.join(2,pg_shares).should == pg.password		
			end										
		end
		describe "user password" do
			let(:empty) { PasswordSplitter.new }
			let!(:pass) { "I love yoO $$ a Bu$hel!! \n and \t peck...." }
			let!(:ps) { PasswordSplitter.new(5,3,pass) }
			let!(:ps_missing_shares) { ps.shares.drop(3).join("\n") }
			it "should raise error if not enough shares" do
				expect {empty.join(3,ps_missing_shares)}.to raise_error('Not enough shares')
			end
			3.times do |x|
				it "should retrieve the password in various share combos" do	
					empty.join(3,ps.shares.rotate(x).drop(2).join("\n")).should == pass
				end						
			end		
		end
		describe "white space characters in input string" do
			let(:empty) { PasswordSplitter.new }
			let!(:pass) { "I love yoO $$ a Bu$hel!! \n and \t peck...." }
			let!(:ps) { PasswordSplitter.new(5,3,pass) }
			["\r\n","\r","\n","\t"," ","\n ","\r\n\t"].each do |example|
				it "should retrieve the password" do	
					empty.join(3,ps.shares.drop(2).join(example)).should == pass
				end					
			end
			['','x',','].each do |example|
				it "should not retrieve the password" do	
					expect{empty.join(3,ps.shares.drop(2).join(example))}.to raise_error(RuntimeError,'Not enough shares')
				end					
			end								
		end
	end
end