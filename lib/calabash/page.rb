module Calabash

  # A base class for the Page Object Model (POM) or Page Object Pattern.
  #
  # We recommend the POM for testing cross-platform apps.
  #
  # We have a great examples of using the POM in the Calabash 2.0 repository.
  #   * https://github.com/calabash/calabash/tree/develop/samples/wordpress
  #   * https://github.com/calabash/calabash/tree/develop/samples/shared-page-logic
  class Page
    # For auto-completion
    include Calabash

    # @!visibility private
    def self.inherited(subclass)
      # Define the page into global scope
      full_name = subclass.name

      if full_name == 'IOS' || full_name == 'Android'
        raise "Invalid page name '#{full_name}'"
      end

      os_scope = full_name.split('::').first

      if os_scope == 'IOS' || os_scope == 'Android'
        page_name = full_name.split('::', 2).last

        unless Calabash.is_defined?(page_name)
          scopes = page_name.split('::')

          previous_scope = ''

          scopes[0..-2].each do |scope|
            old_scope = Calabash.recursive_const_get("Object::#{os_scope}#{previous_scope}")
            new_scope = Calabash.recursive_const_get("Object#{previous_scope}")

            old_const = old_scope.const_get(scope.to_sym)

            if new_scope.const_defined?(scope.to_sym)
              new_scope.send(:remove_const, scope.to_sym)
            end

            new_scope.const_set(scope.to_sym, old_const.class.allocate)

            previous_scope << "::#{scope}"
          end

          simple_page_name = page_name.split('::').last.to_sym
          new_scope = Calabash.recursive_const_get("Object#{previous_scope}")

          unless new_scope.const_defined?(simple_page_name, false)
            clz = Class.new(StubPage)
            new_scope.const_set(simple_page_name, clz)
          end
        end
      end
    end

    private_class_method :new

    # @!visibility private
    def initialize(world)
      @world = world
    end

    # A query that distinguishes your page.
    # @return [String, Hash, Calabash::Query] A query.
    def trait
      raise 'Implement your own trait'
    end

    # Waits for the page trait to appear.
    def await(options={})
      wait_for_view(trait, options)
    end

    # @!visibility private
    class StubPage

    end
  end
end
