require 'kaminari/models/nobrainer_criteria_methods'
require 'kaminari/models/page_scope_methods'
module Kaminari
  module NoBrainerExtension
    module Criteria
      extend ActiveSupport::Concern
      include Kaminari::ConfigurationMethods
      include Kaminari::NoBrainerCriteriaMethods
      include Kaminari::PageScopeMethods
    end
    module Document
      extend ActiveSupport::Concern
      include Kaminari::ConfigurationMethods

      included do
        # Fetch the values at the specified page number
        #   Model.page(5)
        scope Kaminari.config.page_method_name, Proc.new {|num|
          limit(default_per_page).offset(default_per_page * ([num.to_i, 1].max - 1))
        } do
          include Kaminari::NoBrainerCriteriaMethods
          include Kaminari::PageScopeMethods
        end
      end
    end
  end
end
