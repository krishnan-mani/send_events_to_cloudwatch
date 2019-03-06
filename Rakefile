require_relative 'lib/log_events_generator'
require_relative 'lib/log_events_publisher'

desc 'puts a number of log events with the specified pattern in the CloudWatch log group'
task :put_log_events, [:log_line, :pattern, :min_value, :max_value, :number_of_items, :log_group_name, :region] do |t, args|
  log_line = args.log_line || ENV['LOG_LINE']
  pattern = args.pattern || ENV['PATTERN']
  min_value = (args.min_value || ENV['MIN_VALUE']).to_i
  max_value = (args.max_value || ENV['MAX_VALUE']).to_i
  number_of_log_events = (args.number_of_items || ENV['NUMBER_OF_LOG_EVENTS']).to_i

  log_group_name = args.log_group_name || ENV['LOG_GROUP_NAME']
  region = args.region || ENV['AWS_REGION']

  log_events_data = LogEventsGenerator.new(log_line, pattern).get_log_events(number_of_log_events, min_value, max_value)
  log_events, log_stream_name = log_events_data[:log_events], log_events_data[:log_stream_name]
  puts LogEventsPublisher.new(region).put_log_events(log_events, log_group_name, log_stream_name)

end