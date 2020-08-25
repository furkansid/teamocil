module Teamocil
  module Command
    class SelectWindow < ClosedStruct.new(:index)
      def to_s
        "select-window -t #{Teamocil.session}:#{index}"
      end
    end
  end
end
