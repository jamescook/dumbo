require 'pry'
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
      expect(subject.children.first.data[:tag]).to eq(:tag_html)
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

  context "GumboElement" do
    let(:document) { Dumbo.parse("<html lang=en><head><title>Foo</title></head></html>").document.data }
    let(:html) { document.children.first.data }
    let(:head) { html.children.first.data }
    let(:title) { head.children.first.data }

    it "has a head tag" do
      expect(head[:tag]).to eq(:tag_head)
    end

    it "can get to the title" do
      expect(title[:tag]).to eq(:tag_title)
    end

    it "can get to the title's text" do
      expect(title.children.first.text).to eq("Foo")
    end

    it "can get to an attribute" do
      attr = html.attributes.first
      expect(attr).to be_instance_of(Dumbo::GumboAttribute)
      expect(attr.name).to eq("lang")
      expect(attr.value).to eq("en")
    end
  end
end
