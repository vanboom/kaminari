module Kaminari
  module NoBrainerCriteriaMethods
    def initialize_copy(other) #:nodoc:
      @total_count = nil
      super
    end

    def entry_name
      model_name.human.downcase
    end

    def limit_value #:nodoc:
      self._limit
    end

    def offset_value #:nodoc:
      self._skip
    end

    def total_count #:nodoc:
      # this doesn't work, unscoped does not remove the limit
      unpage.count
    end

    private
    def unpage
      NoBrainer::Criteria.new(:klass=>self.klass)
    end
  end
end
