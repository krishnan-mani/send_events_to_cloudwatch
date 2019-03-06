class LogEventsGenerator

  MAXIMUM_LOG_EVENTS_PER_BATCH = 10000

  attr_reader :log_line, :pattern

  def initialize(log_line, pattern)
    @log_line = log_line
    @pattern = pattern
    @random = Random.new
  end

  def get_log_events(number_of_items, min_value, max_value)
    seed_timestamp_milliseconds = Time.now.to_i * 1000
    number_of_log_events = [number_of_items, MAXIMUM_LOG_EVENTS_PER_BATCH].min
    log_events = 1.upto(number_of_log_events).collect {|n| LogEvent.new(seed_timestamp_milliseconds + n, "#{get_message(min_value, max_value)}").to_event}
    {log_stream_name: "synthetic-#{seed_timestamp_milliseconds}", log_events: log_events}
  end

  private

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
