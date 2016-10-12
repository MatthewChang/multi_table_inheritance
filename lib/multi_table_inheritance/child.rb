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
    def method_missing method, *args, &block
      if delegate_to_super?(method)
        mti_parent.send(method,*args,&block)
      else
        super
      end
    end

    def respond_to_missing? method, include_private = false
      super || delegate_to_super?(method)
    end

    private

    def delegate_to_super? method
      #blacklist some methods
      ![:mti_child].include?(method) && mti_parent.respond_to?(method)
    end

    def check_parent_valid
      unless mti_parent.valid?
        mti_parent.errors.each do |att, message|
          errors.add(att, message)
        end
      end
    end
  end

  module ChildStaticMethods
    def method_missing method, *args, &block
      if delegate_to_super?(method)
        result = mti_parent_class.send(method,*args,&block)
        if result.is_a? ActiveRecord::Relation
          all.scoping {result}
        else
          result
        end
      else
        super
      end
    end

    def respond_to_missing? method, include_private = false
      super || delegate_to_super?(method)
    end

    private

    def delegate_to_super? method
      #blacklist some methods
      ![:blacklist].include?(method) && mti_parent_class.respond_to?(method)
    end
  end
end
