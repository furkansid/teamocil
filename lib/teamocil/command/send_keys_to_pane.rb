module Teamocil
  module Command
    class SendKeysToPane < ClosedStruct.new(:index, :keys)
      def to_s
        "send-keys -t '#{Teamocil.session}:#{index}' '#{keys}'"
      end
    end
  end
end
