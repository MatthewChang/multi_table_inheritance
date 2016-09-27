class Vehicle < ActiveRecord::Base
  enum status: { okay: 0, bad: 1 }
  default_scope -> {okay}
end
