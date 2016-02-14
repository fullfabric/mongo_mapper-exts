module MongoMapper
  module Exts
    module UniqueName

      extend ActiveSupport::Concern

      included do
        before_validation :_set_name
      end

      module ClassMethods

        def unique_name name
          @unique_name_association_name = name.to_sym
        end

      end

      def _set_name
        self.name = _get_unique_name if name.blank?
      end

      def _get_unique_name
        _name_exists?( "__#{label.parameterize.underscore}" ) ? "__#{label.parameterize.underscore}_#{self[:_id]}" : "__#{label.parameterize.underscore}"
      end

      def _name_exists? name_to_check
        association_name = self.class.instance_variable_get :@unique_name_association_name
        _parent_document.send( association_name.to_sym ).any? { |child| child.name == name_to_check }
      end

    end
  end
end
