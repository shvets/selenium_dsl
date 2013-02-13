module SeleniumDSL
  if RUBY_VERSION.to_f < 1.9
    class BlankSlate
      instance_methods.each { |m| undef_method m unless m =~ /^__|instance_eval|object_id/ }
    end

    PROXY_CLASS = BlankSlate
  else
    PROXY_CLASS = BasicObject
  end

  class Proxy < PROXY_CLASS
    def initialize subject, methods_to_override=[]
      @subject = subject

      singleton_class = (class << self; self; end)

      # these methods are already defined in core classes: we need to override them
      methods_to_override.each do |method|
        singleton_class.send :define_method, method do |*args|
          @subject.send method, *args
        end
      end
    end

    private

    def method_missing(name, *args, &block)
      @subject.send(name, *args, &block)
    end

    def respond_to?(method)
      @subject.respond_to?(method)
      super
    end
  end
end
