module Timecop
  class TimeStackItem

    getter mock_type : Symbol

    delegate :year, :month, :day, :hour, :minute, :second, to: :time

    @travel_offset : Time::Span
    @time_was : Time

    def initialize(@mock_type, @scaling_factor = 1.0, @time = Time.new)
      initialize(@mock_type, @time, @scaling_factor)
    end

    def initialize(@mock_type, @time : Time = Time.now, @scaling_factor = 1.0)
      if ![:freeze, :travel, :scale].includes?(mock_type)
        raise "Unknown mock_type #{@mock_type}"
      end
      @travel_offset = @time - Time.now_without_mock_time
      @time_was = Time.now_without_mock_time
    end

    #:nodoc:
    def time(location : Time::Location = Time::Location.local) : Time
      case @mock_type
      when :freeze
        @time
      when :travel
        Time.now_without_mock_time(location) + @travel_offset
      when :scale
        @time + (Time.now_without_mock_time(location) - @time_was) * @scaling_factor
      else
        raise "Unknown mock_type #{@mock_type}"
      end
    end
  end
end
