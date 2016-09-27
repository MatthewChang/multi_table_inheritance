require 'multi_table_inheritance/base'
require 'multi_table_inheritance/child'
require 'multi_table_inheritance/parent'

module ActiveRecord
  class Base
    include MultiTableInheritance::Base
  end
end
