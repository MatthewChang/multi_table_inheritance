require 'byebug'

module MultiTableInheritance
  module Relation extend ActiveSupport::Concern
    def specific
      self.map(&:specific)
    end

    def where *args
      byebug
      super
    end
  end
end
