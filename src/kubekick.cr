require "./kubekick/cli"

begin
  Kubekick::CLI.start(ARGV)
rescue ex
  if ENV["KUBEKICK_DEBUG"]?
    raise ex
  else
    STDERR.puts ex.message
  end
end
