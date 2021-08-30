# frozen_string_literal: true

require "active_model"
require "active_support"

require "spicerack"
require "conjunction"
require "malfunction"

require_relative "flow/version"

require_relative "flow/errors"

require_relative "flow/concerns/transaction_wrapper"

require_relative "flow/malfunction/base"

# TODO: Remove inheritance nonsense, just use Substance once deprecation is removed from Spicerack
class Flow::RootObject < (defined?(Substance::RootObject) ? Substance::RootObject : Spicerack::RootObject); end
class Flow::InputModel < (defined?(Substance::InputModel) ? Substance::InputModel : Spicerack::InputModel); end

require_relative "flow/flow_base"
require_relative "flow/operation_base"
require_relative "flow/state_base"
require_relative "flow/state_proxy"
