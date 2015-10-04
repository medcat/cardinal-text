# encoding: utf-8

require 'livescript'
require 'tilt'

module Sprockets
  module Livescript
    #
    class Template < ::Tilt::Template
      self.default_mime_type = 'application/javascript'

      def self.engine_initialized?
        defined? ::LiveScript && ::LiveScript.respond_to?('compile')
      end

      def initialize_engine
      end

      def prepare
      end

      def evaluate(_scope, _locals)
        @output ||= LiveScript.compile(data, options)
      end

      def allows_script?
        false
      end
    end
  end
end
