module Kaminari
  module NoBrainerScopeMethods
    # Specify the <tt>per_page</tt> value for the preceding <tt>page</tt> scope
    #   Model.page(3).per(10)
    def per(num)
      limit(num.to_i).offset(offset_value / limit_value * num.to_i)
    end

    def padding(num)
      @_padding = num
      offset(offset_value + num.to_i)
    end

    # Total number of pages
    def total_pages
      count_without_padding = total_count
      count_without_padding -= @_padding if defined?(@_padding) && @_padding
      count_without_padding = 0 if count_without_padding < 0

      total_pages_count = (count_without_padding.to_f / limit_value).ceil
      total_pages_count
    rescue FloatDomainError => e
      raise ZeroPerPageOperation, "The number of total pages was incalculable. Perhaps you called .per(0)?"
      end
    #FIXME for compatibility. remove num_pages at some time in the future
    alias num_pages total_pages

    # Current page number
    def current_page
      offset_without_padding = offset_value
      offset_without_padding -= @_padding if defined?(@_padding) && @_padding
      offset_without_padding = 0 if offset_without_padding < 0

      (offset_without_padding / limit_value) + 1
    rescue ZeroDivisionError => e
      raise ZeroPerPageOperation, "Current page was incalculable. Perhaps you called .per(0)?"
      end

    # Next page number in the collection
    def next_page
      current_page + 1 unless last_page? || out_of_range?
    end

    # Previous page number in the collection
    def prev_page
      current_page - 1 unless first_page? || out_of_range?
    end

    # First page of the collection?
    def first_page?
      current_page == 1
    end

    # Last page of the collection?
    def last_page?
      current_page == total_pages
    end

    # Out of range of the collection?
    def out_of_range?
      current_page > total_pages
    end
  end
end