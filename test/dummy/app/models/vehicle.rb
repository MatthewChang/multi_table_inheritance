class Vehicle < ActiveRecord::Base
  enum status: { okay: 0, bad: 1 }
  default_scope -> {okay}

  def can_drive?
    wheels % 2 == 0
  end

  #Expects a block which returns a number
  def method_args_test(a,b)
    a + b + yield
  end
end
