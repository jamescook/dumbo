require_relative '../../lib/dumbo'

describe "Parsing" do
  it "can parse" do
    expect{ Dumbo.parse("<html></html>") }.to_not raise_error
  end

  context "a basic html document" do
    subject{ Dumbo.parse("<html></html>") }

    it "returns a GumboOutputStruct" do
      expect(subject).to be_instance_of(Dumbo::GumboOutputStruct)
    end

    it "wraps a document" do
      expect(subject.document).to be_instance_of(Dumbo::GumboNode)
    end

    it "wraps a root" do
      expect(subject.root).to be_instance_of(Dumbo::GumboNode)
    end

    it "wraps errors" do
      expect(subject.errors).to be_instance_of(Dumbo::GumboVector)
    end
  end
end
