class LogEventsGenerator

  ONE_MINUTE_AS_SECONDS = 60
  MINUTES_OFFSET = 50
  TIME_OFFSET = MINUTES_OFFSET * ONE_MINUTE_AS_SECONDS

  MAXIMUM_LOG_EVENTS_PER_BATCH = MINUTES_OFFSET - 10

  attr_reader :log_line, :pattern

  def initialize(log_line, pattern)
    @log_line = log_line
    @pattern = pattern
    @random = Random.new
  end

  def get_log_events(number_of_log_events, min_value, max_value)
    start_timestamp_milliseconds = get_start_timestamp_milliseconds
    number_of_log_events = [number_of_log_events, MAXIMUM_LOG_EVENTS_PER_BATCH].min
    log_events = 1.upto(number_of_log_events).collect {|n| LogEvent.new(get_next_minute_timestamp(n, start_timestamp_milliseconds), "#{get_message(min_value, max_value)}").to_event}
    {log_stream_name: "synthetic-#{start_timestamp_milliseconds}", log_events: log_events}
  end

  private

  def get_next_minute_timestamp(n, start_timestamp_milliseconds)
    start_timestamp_milliseconds + (n * ONE_MINUTE_AS_SECONDS * 1000)
  end

  def get_start_timestamp_milliseconds
    (Time.now - TIME_OFFSET).to_i * 1000
  end

  def get_message(min_value, max_value)
    log_line.gsub(pattern, @random.rand(min_value..max_value).to_s)
  end

end

class LogEvent
  attr_reader :time_since_epoch, :message

  def initialize(time_since_epoch, message)
    @time_since_epoch, @message = time_since_epoch, message
  end

  def to_event
    {
        timestamp: time_since_epoch,
        message: message
    }
  end
end
