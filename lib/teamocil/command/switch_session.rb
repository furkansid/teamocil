
module Teamocil
  module Command
    class SwitchSession < ClosedStruct.new(:name)
      def to_s
        "switch -t '#{name}'"
      end
    end
  end
end
