describe MongoMapper::Exts::UniqueName do

  class ChildDocument

    include MongoMapper::EmbeddedDocument
    include MongoMapper::Exts::UniqueName

    unique_name :children

    embedded_in :parent_document

    key :name, String
    key :label, String

  end

  class ParentDocument

    include MongoMapper::Document

    many :children, class: ChildDocument

  end

  it "sets the name of the partial based on the label" do

    document = ParentDocument.new
    document.children << child = ChildDocument.new( label: "Work Group A" )

    document.valid?

    expect( child.name ).to eq "__work_group_a"

  end


  context "duplicate name across several grades" do

    it "sets a unique name" do

      document = ParentDocument.new
      document.children << child_1 = ChildDocument.new( label: "Work Group A" )
      document.children << child_2 = ChildDocument.new( label: "Work Group A" )

      document.valid?

      expect( child_1.name ).to_not eq child_2.name

    end

  end


end
