module MultiTableInheritance
  module Base extend ActiveSupport::Concern
    included do
      class_attribute :mti_parent_class
    end

    module ClassMethods
      #This is pretty wack, but not sure a better way to selectively run code in the
      #instantiate call that is threadsafe
      def __bypass_instantiate
        yield
      end

      def mti_parent_classes
        if mti_parent_class
          (mti_parent_class.mti_parent_classes || []) << mti_parent_class
        else
          []
        end
      end

      def mti_parent_table
        self.mti_parent_class.table_name.to_sym
      end

      def mti_parent_symbol
        mti_parent_table.to_s.singularize.to_sym
      end

      def mti_extends klass
        self.setup_child_for klass
        klass.setup_parent
      end

      def setup_child_for klass
        include MultiTableInheritance::ChildInstanceMethods
        self.mti_parent_class = klass
        class_eval "def #{name}; super || build_#{name} end"


        has_one mti_parent_symbol, as: :child
        self.class_eval <<-Ruby, __FILE__, __LINE__ + 1
          def #{mti_parent_symbol}
            self.class.__bypass_instantiate {super || build_#{mti_parent_symbol}}
          end
        Ruby
        after_save :save_parent
      end

      def setup_parent
        belongs_to :child, polymorphic: true
        extend MultiTableInheritance::ParentStaticMethods
        include MultiTableInheritance::ParentInstanceMethods
      end
    end
  end
end
