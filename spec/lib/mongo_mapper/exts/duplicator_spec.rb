describe MongoMapper::Exts::Duplicator do

  class Page
    include MongoMapper::EmbeddedDocument
  end

  class Chapter
    include MongoMapper::EmbeddedDocument
    key :title, String
    many :pages, class: Page
  end

  class Book

    include MongoMapper::Document
    include MongoMapper::Exts::Duplicator

    key :title, String
    many :chapters, class: Chapter

    key :author_names, Array

  end

  let!( :book )      { Book.new title: Faker::Lorem.sentence, chapters: [ chapter_1, chapter_2 ], author_names: [ "Peter", "Paul" ] }
  let ( :chapter_1 ) { Chapter.new title: Faker::Lorem.sentence, pages: [ page_1, page_2 ] }
  let ( :chapter_2 ) { Chapter.new title: Faker::Lorem.sentence, pages: [ page_3, page_4 ] }
  let ( :page_1 )    { Page.new title: Faker::Lorem.sentence }
  let ( :page_2 )    { Page.new title: Faker::Lorem.sentence }
  let ( :page_3 )    { Page.new title: Faker::Lorem.sentence }
  let ( :page_4 )    { Page.new title: Faker::Lorem.sentence }

  context "duplicating attributes" do

    it "removes specified keys" do

      book_attributes = book.duplicate_attributes( blacklist: [ :_id ] )

      expect( book_attributes ).to_not have_key :_id
      expect( book_attributes[ :chapters ][0] ).to_not have_key :_id
      expect( book_attributes[ :chapters ][0][ :pages ][0] ).to_not have_key :_id
      expect( book_attributes[ :chapters ][0][ :pages ][1] ).to_not have_key :_id

      expect( book_attributes[ :chapters ][1] ).to_not have_key :_id
      expect( book_attributes[ :chapters ][1][ :pages ][0] ).to_not have_key :_id
      expect( book_attributes[ :chapters ][1][ :pages ][1] ).to_not have_key :_id

    end

  end

end
