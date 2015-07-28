require './sorghum'

# We could enable this, but it isn't very helpful...
# info_log = File.new('logs/stdout.log', 'a+')
# $stdout.reopen(info_log)
# $stdout.sync = true

# If you uncomment the stuff up there, you probably want to rename the log here:
#error_log = File.new('logs/stderr.log', 'a+')
# Otherwise, do this if you're so inclined:
# error_log = File.new('logs/info.log', 'a+')
# $stderr.reopen(error_log)
# $stderr.sync = true

run SorghumApp