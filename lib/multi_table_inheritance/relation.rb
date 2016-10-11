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
      #byebug
      puts args
      # new_args = {}
      # args.each do |k,v|
      #   if v.is_a? Hash || !klass.mti_delegates_query?(k)
      #     new_args[k] = v
      #   else
      #     new_args[klass.mti_delegate_query(k)] = v
      #   end
      # end
      # super(new_args)
      super
    end
  end
end
