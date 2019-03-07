What 
---
- Generate some log events based on a text pattern and write them to an AWS CloudWatch log group
- You can run this as a [Docker container](https://cloud.docker.com/repository/docker/kmdemos/send-events-to-cloudwatch)

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

$ rake put_log_events['abc foo_placeholder def','foo_placeholder',50,70,30,'test-log-group','eu-west-1']

```

This will generate 30 log lines (a.k.a. events) that each look like `abc <N> def`, 
with N substituted by a randomly chosen integer between the lower bound (50) and upper bound (70),
and will publish these log events into the named log group in the specified AWS region.

Each log event will have a timestamp beginning at 50 minutes in the past, advancing by 1 minute on each log event.
A maximum of 40 log events can be generated.

To understand limitations on timestamp of log events that can be published to CloudWatch Logs, see [here](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudWatchLogs/Client.html#put_log_events-instance_method)

At each run, a new log stream is created within the log group that is named `synthetic-<TIMESTAMP>`,
where TIMESTAMP is the time since epoch (in milliseconds) when the task was run, 
and the log events are published into this log stream. 

The response from the API call `put_log_events` is printed. This looks like the following:

```ruby

{:next_sequence_token=>"49593595059719128983591384647393373584404458978366498066", :rejected_log_events_info=>nil}

```  

How (with Docker)
---

- (optional) build a Docker image locally

```
# build the Docker image locally, if you like
$ docker build . -t send-events-to-cloudwatch

```

- Run a Docker container from the publicly-available image 
    - Please see [`env.list.example`](env.list.example) that illustrates the environment variables to be configured to run the container
    - _Remember_! Do NOT check-in credentials into version control or bake into Docker images!!!

```
# Run the docker container

$ cp env.list.example env.list
# Edit env.list and provide the values, including AWS credentials, etc.

$ docker run \
    --rm \
    --env-file env.list \
    kmdemos/send-events-to-cloudwatch:1.0 \
    bundle exec rake put_log_events

```
