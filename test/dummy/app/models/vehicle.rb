class Vehicle < ActiveRecord::Base
  include MTI
  # actable
  enum status: { okay: 0, bad: 1 }
  default_scope -> {okay}
end
