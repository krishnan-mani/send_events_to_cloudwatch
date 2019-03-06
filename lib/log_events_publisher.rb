require 'aws-sdk-cloudwatchlogs'

class LogEventsPublisher
  def initialize(region)
    @client = Aws::CloudWatchLogs::Client.new(region: region)
  end


  def put_log_events(log_events, log_group_name, log_stream_name)
    create_log_stream(log_group_name, log_stream_name)
    response = @client.put_log_events({
                               log_group_name: log_group_name,
                               log_stream_name: log_stream_name,
                               log_events: log_events
                           })

    response
  end

  private

  def create_log_stream(log_group_name, log_stream_name)
    @client.create_log_stream(log_group_name: log_group_name, log_stream_name: log_stream_name)
  end

end