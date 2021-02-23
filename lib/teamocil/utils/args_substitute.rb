module Teamocil
  class ArgumentSubstitute
    l_identifier = '['
    r_identifier = ']'
    @@r1_regex = Regexp.new "(?<=\\%{l_})(.*?)(?=\\%{r_})" % {l_: l_identifier, r_: r_identifier}

    def sub_one(s_args, v_hash)
      @@r1_regex.match(s_args).captures
      if $1
        if not v_hash.has_key?($1)
          raise ArgumentError, "Need to provide all argument which needs to be substitue"
        else
          s_args["[%{_}]" % {_: $1}] = v_hash[$1]
        end
      end
      return s_args
    end

    def sub_all(s_args, v_hash)
      while @@r1_regex.match?(s_args)
        s_args = sub_one(s_args, v_hash)
      end
      return s_args
    end

  end
end
