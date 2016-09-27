module MultiTableInheritance
  module ParentStaticMethods
    #find child instances here
    #Did some benchmarking and dumping the call stack is almost neglibable compared
    #to the cost of sql calls; < 1/20th of the time
    #Overrides funcitonality of http://apidock.com/rails/ActiveRecord/Base/instantiate/class
    def instantiate(*args)
      bypassed = caller_locations.reduce(false) {|v,e| v || e.label == "__bypass_instantiate"}
      unless bypassed
        super.specific
      else
        super
      end
    end
  end

  module ParentInstanceMethods
    def specific
      if child.respond_to? :specific
        child.specific
      else
        child
      end
    end
  end
end
