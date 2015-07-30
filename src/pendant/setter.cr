module Pendant::Setter
  def []=(key, value)
  end

  def keys
  end

  macro define_pendant_setters
    def []=(key, value : T)
      {% for m in @type.methods %}
        {% if m.args.length == 1 && m.name.stringify.ends_with?("=") && m.name.stringify != "[]=" %}
          if key == {{ m.name.stringify[0..-2] }} || key == :{{ m.name.stringify[0..-2] }}
            return self.{{ m.name }}(value)
          end
        {% end %}
      {% end %}

      {% if @type.superclass && @type.superclass.methods.any?{|m|m.name.stringify == "[]=" && m.args.length == 2} %}
        super
      {% else %}
        raise KeyError.new "Missing key value: #{key.inspect}"
      {% end %}
    end

    @@%keys = nil
    def keys
      if keys = @@%keys
        keys
      else
        keys = {{ @type.methods.select do |m|
          m.args.length == 1 && m.name.ends_with?("=") && m.name.stringify != "[]="
        end.map{|m|m.name.stringify[0..-2]} }} of String

        {% if @type.methods.any?{|m|m.name.stringify == "keys" && m.args.length == 0} %}
          keys.concat(previous_def)
        {% end %}
        {% if @type.superclass && @type.superclass.methods.any?{|m|m.name.stringify == "keys" && m.args.length == 0} %}
          keys.concat(super)
        {% end %}
        keys.uniq!
        @@%keys = keys
        keys
      end
    end

    macro inherited
      define_pendant_setters
    end

    macro included
      define_pendant_setters
    end
  end

  macro included
    define_pendant_setters
  end
end
