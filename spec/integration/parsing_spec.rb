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

  context "GumboNode" do
    subject{ Dumbo.parse("<html></html>").document }

    it "knows its parse_flags" do
      expect(subject.parse_flags).to eq(:insertion_by_parser)
    end

    it "has data of the appropriate type" do
      expect(subject.data).to be_instance_of(Dumbo::GumboDocument)
    end
  end

  context "GumboDocument" do
    subject{ Dumbo.parse("<html></html>").document.data }

    it "knows its children" do
      expect(subject.children).to be_instance_of(Dumbo::GumboVector)
    end

    it "knows if it has a doctype" do
      expect(subject.has_doctype).to eq(false)
    end

    it "has a name" do
      expect(subject.name).to eq("")
    end

    context "with a doctype" do
      subject{ Dumbo.parse("<!DOCTYPE html><html></html>").document.data }
      it "has a doctype" do
        expect(subject.has_doctype).to eq(true)
      end
    end
  end

  context "GumboVector" do
    subject{ Dumbo.parse("<html></html>").document.data.children }

    it "has a length" do
      expect(subject.length).to eq(1) # The html node
    end

    it "has some data" do
      expect(subject.data).to eq(1) # The html node
    end
  end
end
