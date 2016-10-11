require 'multi_table_inheritance/base'
require 'multi_table_inheritance/child'
require 'multi_table_inheritance/parent'
require 'multi_table_inheritance/relation'

module ActiveRecord
  class Base
    include MultiTableInheritance::Base
  end
  module Delegation
    module ClassSpecificRelation
      include MultiTableInheritance::Relation
    end
  end
end
