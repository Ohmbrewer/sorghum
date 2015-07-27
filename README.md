# Sorghum
## A Gluten-free mock for Ohmbrewer

### Forward
#### Wut?
Suppose you want to work with a Particle (formerly Spark) device using Ruby. 
Suppose that you don't want to duplicate efforts (read: you're lazy), so naturally, you're using Julien Vanier's excellent
[ParticleRb gem](https://github.com/monkbroc/particlerb). Finally, suppose you want to get the information your device
is putting out via Spark.publish()

#### K...
Theeeen you're going to be using webhooks.

#### K...
Then you need a web server.

#### K...
Now suppose you just want to test that your Particle-based device is outputting what you expect in a programmatic fashion.
In other words, suppose you don't really want to run your full application.

#### FUUUUUUU...
Exactly. That's why we've developed Sorghum. 

It's easier than trying to implement an EventMachine Server-Sent Events consumer. It requires minimal development and
maintenance. It's gluten-free.

### Description
Sorghum is a stupid simple Sinatra app that mainly just provides an end-point to lob webhooks at. All it does is receive
POST messages at event end-points Ohmbrewer supplies and dump what it receives into some handy locations.

Currently, Sorghum sends all server logging messages (including webhook receiving info) to sorghum/logs/info.log. 
If you're so inclined, you can parse that to determine what time something was received.

Additionally, the last message received for a given event route will be saved in `sorghum/logs/last_EVENTNAME_event.log`.
For example, the last message sent to `/pumps` will be found in `sorghum/logs/last_pumps_event.log`. You can also access
this log by sending a GET request to `/last/EVENTNAME`.

This last event dealie isn't great for running tests in parallel, but otherwise it provides a pretty decent way of 
checking for receipt of a single message as long as you account for transmission time. Again, we're going for simplicity,
not production-readiness.

Finally, all messages are passed around as JSONs, in case you're interested. Just throwing that out there.

### Installation
You'll want to make sure you've installed all the gems in the Gemfile, so make sure to run 

```bash
bundle install
```

from the `sorghum` directory.

### Running
Sorghum is Sinatra app built in the "Modular" style. That means you're going to want to run it via Rack. We've provided 
a config.ru file to make that easier. Regardless, it goes like this:

```bash
rackup -o 0.0.0.0 -p 4567 config.ru
```

If you're using RubyMine, the run configuration will look like this:
```yaml
Server: default
IP address: 0.0.0.0
Port: 4567
Rack config file: config.ru
```

In order to communicate with Particle's cloud services, Sorghum will need to be accessible to the Internet at large. 
If you're running Sorghum on your localhost, the easiest way to do that now is to use [NGrok](https://ngrok.com/) to punch a hole down to it.
Check out [Brandon West's blog post on the subject](https://sendgrid.com/blog/simple-webhook-testing-using-sinatra-ngrok/)
for the nitty-gritty. Remember, though, the main difference here is that we aren't using SendGrid, we're using Sorghum.

Of course, you should be able to get around the NGrok requirement by running on some sort of publicly accessible web server
(AWS, Heroku, Cloud9(???), etc.), but I haven't given this a shot yet and depending on the service you may have difficulties getting
at the logs. If you want to go this route, the work is left up to the reader :wink:

#### Docker
Alternatively, we've got a Dockerfile if you want to build a Docker container and a Docker Compose file to make it even easier.
All you have to do is:

```bash
docker-compose build
docker-compose up
```

Booyah! You should have Sorghum running on port 5000. If you don't feel like building it yourself, we've got an image on [Docker Hub too](https://registry.hub.docker.com/u/ohmbrewer/sorghum/), but we can't guarantee it'll be the most up-to-date (yet).

### Tests
![alt text](https://i.imgflip.com/opv8j.jpg "YO DAWG, I HEARD YOU LIKE TESTS AND MOCKS, SO I WROTE SOME TESTS SO YOU CAN TEST THE MOCK YOU'LL USE TO TEST YOUR MOCK")

That said, check out the `sorghum/test` directory. There's MiniTest tests for what we support so far.

If you add something else, make sure to create a test for it.

### Props
Mad props to [Julien Vanier](https://github.com/monkbroc) for writing the ParticleRb gem and 
[Brandon West](https://sendgrid.com/blog/simple-webhook-testing-using-sinatra-ngrok/) for writing just the blog post I 
was looking for after trying to attack this particular challenge from a few different angles. That post made for a good
jumping off point.
