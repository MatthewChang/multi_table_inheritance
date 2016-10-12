require 'byebug'

module MultiTableInheritance
  module Relation extend ActiveSupport::Concern
    def specific
      self.map(&:specific)
    end


    # Overrides where to find the proper table for delegates query options
    #
    # @return [ActiveRecord_Relation] relation with new query options
    def where args
      return super unless args.is_a? Hash
      new_args = {}
      args.each do |k,v|
        if v.is_a?(Hash) || !klass.mti_delegates_query?(k)
          new_args[k] = v
        else
          table = klass.mti_delegate_query_table(k)
          new_args[table] ||= {}
          new_args[table][k] = v
        end
      end
      super(new_args)
    end

    def scoping
      super_value = super
      if super_value.class == self.class || !super_value.is_a?(ActiveRecord::Relation)
        super_value
      else
        self.merge(super_value)
      end
    end
  end
end
