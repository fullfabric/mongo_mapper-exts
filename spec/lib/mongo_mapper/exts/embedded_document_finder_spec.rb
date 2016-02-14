describe MongoMapper::Exts::EmbeddedDocumentFinder do

  class DeepEmbeddedDocumentWithFinder

    include MongoMapper::EmbeddedDocument
    include MongoMapper::Exts::EmbeddedDocumentFinder

    find_through "Document", path: "embedded_documents.deep_embedded_documents"

    embedded_in :embedded_document

  end

  class DeepEmbeddedDocumentForHasOneWithFinder

    include MongoMapper::EmbeddedDocument
    include MongoMapper::Exts::EmbeddedDocumentFinder

    find_through "Document", path: "embedded_documents.deep_embedded_document"

    embedded_in :embedded_document

  end

  class EmbeddedDocumentWithFinder

    include MongoMapper::EmbeddedDocument
    include MongoMapper::Exts::EmbeddedDocumentFinder

    find_through "Document", path: "embedded_documents"

    embedded_in :document

    many :deep_embedded_documents, class: DeepEmbeddedDocumentWithFinder
    one :deep_embedded_document, class: DeepEmbeddedDocumentForHasOneWithFinder

  end

  class Document

    include MongoMapper::Document

    many :embedded_documents, class: EmbeddedDocumentWithFinder

  end

  let! ( :document ) { Document.new }
  let! ( :embedded_document ) { EmbeddedDocumentWithFinder.new }
  let! ( :deep_embedded_document ) { DeepEmbeddedDocumentWithFinder.new }
  let! ( :deep_embedded_document_for_has_one ) { DeepEmbeddedDocumentForHasOneWithFinder.new }

  it "ignores nil id" do

    document.embedded_documents << embedded_document
    document.save!

    expect( EmbeddedDocumentWithFinder.find nil).to be_nil

  end

  it "finds an embedded document by id" do

    document.embedded_documents << embedded_document
    document.save!

    expect( EmbeddedDocumentWithFinder.find embedded_document.id ).to be_a EmbeddedDocumentWithFinder

  end

  it "finds a deeply embedded document" do

    embedded_document.deep_embedded_documents << deep_embedded_document
    document.embedded_documents << embedded_document
    document.save!

    expect( DeepEmbeddedDocumentWithFinder.find deep_embedded_document.id ).to be_a DeepEmbeddedDocumentWithFinder

  end

  context "empty has one association" do

    it "finds a deeply embedded document" do

      document.embedded_documents << EmbeddedDocumentWithFinder.new

      embedded_document.deep_embedded_document = deep_embedded_document_for_has_one
      document.embedded_documents << embedded_document
      document.save!

      expect( DeepEmbeddedDocumentForHasOneWithFinder.find deep_embedded_document_for_has_one.id ).to be_a DeepEmbeddedDocumentForHasOneWithFinder

    end

  end

  context "missing arguments" do

    class EmbeddedDocumentWithFinderButMissingPath

      include MongoMapper::EmbeddedDocument
      include MongoMapper::Exts::EmbeddedDocumentFinder

      find_through "Document"

      embedded_in :document

    end

    it "requires the path to be passed in" do
      expect{ EmbeddedDocumentWithFinderButMissingPath.find BSON::ObjectId.new }.to raise_error
    end

  end

  context "embedded document does not exist" do

    it "raises an exception" do
      expect{ EmbeddedDocumentWithFinder.find! BSON::ObjectId.new }.to raise_error
    end

  end

end
