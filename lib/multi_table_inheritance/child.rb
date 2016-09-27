module MultiTableInheritance
  module ChildInstanceMethods
    def initialize(*args,&block)
      super
      self.send("#{self.class.mti_parent_symbol}=",mti_parent_class.new)
    end
  end
end
