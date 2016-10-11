require 'byebug'

module MultiTableInheritance
  module Base extend ActiveSupport::Concern
    included do
      class_attribute :mti_parent_class
      # Vehicle::ActiveRecord_Relation
    end


    def specific
      if self.respond_to?(:mti_child) && !mti_child.nil?
        mti_child.specific
      else
        self
      end
    end

    module ClassMethods
      #This is pretty wack, but not sure a better way to selectively run code in the
      #instantiate call that is threadsafe
      def __bypass_instantiate
        yield
      end

      def mti_ancestor_classes
        if mti_parent_class
          (mti_parent_class.mti_ancestor_classes || []) << mti_parent_class
        else
          []
        end
      end

      def mti_parent_table
        self.mti_parent_class.table_name.to_sym
      end
      def mti_ancestor_tables
        self.mti_ancestor_classes.map {|e| e.table_name.to_sym}
      end

      def mti_parent_symbol
        mti_parent_table.to_s.singularize.to_sym
      end
      def mti_ancestor_symbols
        mti_ancestor_tables.map {|e| e.to_s.singularize.to_sym}
      end

      def mti_extends klass
        self.setup_child_for klass
        klass.setup_parent
      end

      def setup_child_for klass
        include MultiTableInheritance::ChildInstanceMethods
        self.mti_parent_class = klass

        has_one mti_parent_symbol, as: :mti_child
        self.class_eval <<-Ruby, __FILE__, __LINE__ + 1
          def #{mti_parent_symbol}
            self.class.__bypass_instantiate {super || build_#{mti_parent_symbol}}
          end
        Ruby
        after_save :save_parent
        mti_ancestor_symbols.each do |e|
          self.default_scope {joins(e)}
        end
      end

      def setup_parent
        belongs_to :mti_child, polymorphic: true
        extend MultiTableInheritance::ParentStaticMethods
        include MultiTableInheritance::ParentInstanceMethods
      end
    end
  end
end
