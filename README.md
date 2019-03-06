What 
---
Generate some log events based on a text pattern and write them to an AWS CloudWatch log group

Motivation 
---
This can be used to test a [CloudWatch Logs metric filter](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringLogData.html)

Pre-requisites
---

- AWS credentials for a user privileged to `create_log_stream` and `put_log_events` in CloudWatch Logs in the desired region must be configured using one of the supported mechanisms (see 'Setting AWS Credentials' on [this page](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html))

How
---

```bash

$ rake -T
rake put_log_events[log_line,pattern,min_value,max_value,number_of_items,log_group_name,region]

$ rake put_log_events['abc foo_placeholder def','foo_placeholder',10,20,100,'test-log-group','eu-west-1']

```

This will generate 100 log lines (a.k.a. events) that each look like `abc <N> def`, 
with N substituted by a randomly chosen integer between the lower bound (10) and upper bound (20),
and will publish these log events into the named log group in the specified AWS region.

At each run, a new log stream is created within the log group that is named `synthetic-<TIMESTAMP>`,
where TIMESTAMP is the time since epoch (in milliseconds) when the task was run, 
and the log events are published into this log stream. 

The response from the API call `put_log_events` is printed. This looks like the following:

```ruby

{:next_sequence_token=>"49593595059719128983591384647393373584404458978366498066", :rejected_log_events_info=>nil}
```  

How (with Docker)
---

Remember! Do not check-in credentials into version control or bake into Docker images!!!

```
$ docker build . -t send-events-to-cloudwatch
$ cp env.list.example env.list

# Edit env.list and provide the values, including AWS credentials, etc.

$ docker run --env-file env.list send-events-to-cloudwatch bundle exec rake put_log_events

```

