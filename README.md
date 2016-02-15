# MongoMapper::Exts

Extensions for MongoMapper

## Installation

```ruby
gem 'mongo_mapper-exts'
```

## Usage

This gem provides several modules that can be included in MongoMapper documents. Please see the specific module documentation for details.

## Modules

### Duplicator

```ruby
class User
  include MongoMapper::Exts::Duplicator
end

attributes = user.duplicate_attributes({ blacklist: 'password_hash' })
```

### EmbeddedDocumentFinder

Finds embedded documents by id. Implements #find, #find! and aliases #find_by_id and #find_by_id!

```ruby
class Institutions::ClassOf
  include MongoMapper::EmbeddedDocument
  include MongoMapper::Exts::EmbeddedDocumentFinder
  find_through 'Institutions::Programme', path: 'classes'
end

Institutions::ClassOf.find!(BSON::ObjectId('56c1048d6e3df19c3e0001db'))
```

### UniqueName

Creates a unique name based on a label.

```ruby
class ParentDocument

  include MongoMapper::Document

  many :children, class: ChildDocument

end

class ChildDocument

  include MongoMapper::EmbeddedDocument
  include MongoMapper::Exts::UniqueName

  unique_name :children

  embedded_in :parent_document

  key :name, String
  key :label, String

end

document = ParentDocument.new
document.children << child = ChildDocument.new( label: "Work Group A" )

child.name # __work_group_a

```

### S3Url::Proxy

Adds 'path' key and updates it based on the value of 'url'. While 'url' stores the original S3 path,
'path' stores the path used by our S3 proxy, allowing us to serve S3 files securily.

```ruby
class ProxyTestSubject

  include MongoMapper::Document

  key :url, String

  include MongoMapper::Exts::S3Url::Proxy

end
```

## Documentation

Run the yard server with the parameters below to have documentation available locally at http://0.0.0.0:9000/

```
yard server -r -p 9000
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mongo_mapper-exts/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
