require 'gringotts'

describe Gringotts::Utils do
  
  it "hash_to_qs should ... work" do
    Gringotts::Utils.hash_to_qs({
      :harry => "potter",
      :ron => "weasley",
      :hermoine => "granger"
    }).should == "harry=potter&ron=weasley&hermoine=granger"
  end
  
end