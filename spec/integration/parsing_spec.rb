require_relative '../../lib/dumbo'

describe "Parsing" do
  it "can parse" do
    expect{ Dumbo.gumbo_parse("<html></html>") }.to_not raise_error
  end
end
