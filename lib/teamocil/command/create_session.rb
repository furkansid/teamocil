module Teamocil
  module Command
    class CreateSession < ClosedStruct.new(:name)
      def to_s
        "new-session -s '#{Teamocil.session}' -d"
      end
    end
  end
end
