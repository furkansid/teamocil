module Teamocil
  class OptionParser
    def initialize(arguments: nil)
      @arguments = arguments
      @parsed_options = {}
    end

    def parsed_options
      @parsed_options.tap do
        parser.parse!(@arguments)
      end
    end

    # rubocop:disable MethodLength
    def get_session
      @parsed_options[:session]
    end

    def parser
      ::OptionParser.new do |parser|
        parser.banner = 'Usage: teamocil [options] <layout>'
        parser.separator ''
        parser.separator 'Specific options:'

        # Global options
        parser.on('--list', 'List all available layouts in `~/.teamocil/`') do
          @parsed_options[:list] = true
        end

        # Single layout options
        parser.on('--here', 'Set up the first layout window in the current tmux window') do
          @parsed_options[:here] = true
        end

        parser.on('--layout [layout]', 'Use a specific layout file, instead of `~/.teamocil/<layout>.yml`') do |layout|
          @parsed_options[:layout] = layout
        end

        parser.on('--edit', 'Edit the YAML layout file instead of using it') do
          @parsed_options[:edit] = true
        end

        parser.on('--show', 'Show the content of the layout file instead of executing it') do
          @parsed_options[:show] = true
        end

        parser.on('-r', '--session [session]', 'Spawn properties on new session, will not spawn if session exists') do |session|
          @parsed_options[:session] = session
        end

        # argument substitute
        parser.on('--c_args [c_args]', 'substitue command') do |c_args|
          #c_args = JSON.parse(c_args)
          puts "flag option_parser", c_args
          @parsed_options[:c_args] = c_args
          #require 'pry'; binding.pry
        end

        # Debug options
        parser.on('--debug', 'Show the commands Teamocil will execute instead of actually executing them') do
          @parsed_options[:debug] = true
        end

        parser.on('--version', '-v', 'Show Teamocil’s version number') do
          Teamocil.puts(VERSION)
          exit
        end
      end
    end
    # rubocop:enable all
  end

end
