require 'multi_table_inheritance/base'
require 'multi_table_inheritance/child'
require 'multi_table_inheritance/parent'
require 'multi_table_inheritance/relation'
require 'multi_table_inheritance/migration'

module ActiveRecord
  class Base
    include MultiTableInheritance::Base
  end
  module Delegation
    module ClassSpecificRelation
      include MultiTableInheritance::Relation
    end
  end
  # module ConnectionAdapters
  #   class TableDefinition
  #     include MultiTableInheritance::Migration::TableDefinition
  #   end
  #   class Table
  #     include MultiTableInheritance::Migration::Table
  #   end
  # end
  class Migration
    include MultiTableInheritance::Migration::SchemaStatements
  end
end
