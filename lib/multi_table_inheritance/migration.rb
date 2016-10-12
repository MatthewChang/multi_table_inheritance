module MultiTableInheritance
  module Migration
    # module TableDefinition
    #   def mti_extendable(options = {})
    #     #name = options.delete(:as) || :actable
    #     #options[:polymorphic] = true
    #     #references(:mti_child, options)
    #     string :mti_child_type
    #   end
    # end
    #
    # module Table
    #   include TableDefinition
    #   # def remove_actable(options = {})
    #   #   #name = options.delete(:as) || :actable
    #   #   options[:polymorphic] = true
    #   #   @base.remove_reference(@name, name, options)
    #   # end
    # end

    module SchemaStatements
      def create_table(table_name, comment: nil, **options)
        extendable = options.delete(:extendable)
        child = options.delete(:mti_child)
        options = options.merge id: false if child
        super do |t|
          t.integer :id, null: false, unique: true if child
          t.string :mti_child_type if extendable
          yield(t)
        end
        #add index here?
      end
    end
  end
end
