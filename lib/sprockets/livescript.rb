# encoding: utf-8

require 'sprockets/livescript/template'

#
module Sprockets
  register_engine '.ls', Livescript::Template,
                  mime_type: 'application/javascript'
end
