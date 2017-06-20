require "spec_helper"

RSpec.describe PhoenixPassword do
  it "has a version number" do
    expect(PhoenixPassword::VERSION).not_to be nil
  end

  it "Generates a combination" do
   expect(PhoenixPassword.new().combinations({:piped=>true,:type=>"matching",:cmb_length=>[6],
    	:characters=>[0,1,2,3,4,5,6,7,8,9],})).not_to be nil
  end
end
