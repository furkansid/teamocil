module Teamocil
  class Layout < ClosedStruct.new(:path)
    def execute!
      if Teamocil.options[:debug]
        Teamocil.puts(shell_commands.join("\n"))
      else
        is_session_available = Teamocil.system(shell_commands[0])
        if is_session_available then
          Teamocil.system(shell_commands[1..].join('; '))
        else
          raise "Duplicate session can't complete operation."
        end
      end
    end

    def show!
      Teamocil.puts(raw_content)
    end

    def edit!
      Teamocil.system("${EDITOR:-vi} #{path}")
    end

    def self.print_available_layouts(directory: nil)
      files = Dir.glob(File.join(directory, '*.yml'))

      files.map! do |file|
        extname = File.extname(file)
        File.basename(file).gsub(extname, '')
      end

      # Always return files in alphabetical order, even if `Dir.glob` almost
      # always does it
      files.sort!

      Teamocil.puts(files)
    end

  private

    def shell_commands
      session.as_tmux.map { |command| "tmux #{command}" }
    end

    def session
      Teamocil::Tmux::Session.new(parsed_content)
    end

    def parsed_content
      data = YAML.load(raw_content)
      d2 = substitue_args(data)
      data
    rescue Psych::SyntaxError
      raise Teamocil::Error::InvalidYAMLLayout, path
    end

    def raw_content
      File.read(path)
    rescue Errno::ENOENT
      raise Teamocil::Error::LayoutNotFound, path
    end

    def substitue_args(data)
      args_substituter = ArgumentSubstitute.new
      if Teamocil.options[:c_args]
        c_args = YAML.load(Teamocil.options[:c_args])
        data['windows'].each { |k| k['panes'].each { |v| if v.class == Hash then v['commands'].each {|command| args_substituter.sub_all(command, c_args) } else args_substituter.sub_all(v, c_args) end}}
      end
      puts data.inspect
    end

  end
end
