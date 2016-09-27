module MultiTableInheritance
  module ChildInstanceMethods
    def save_parent
      mti_parent.save
    end

    def mti_parent
      self.send(self.class.mti_parent_symbol)
    end
    # def initialize(*args,&block)
    #   super
    #   #self.send("#{self.class.mti_parent_symbol}=",mti_parent_class.new)
    # end
  end
end
