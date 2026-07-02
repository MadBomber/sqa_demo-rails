# frozen_string_literal: true

# Version for the sqa-rails demo app. Mirrors the version.rb of the other
# SQA components so the workspace can coordinate all versions uniformly.
#
# NOTE: sqa-rails is a Rails application, not a packaged gem — this file is a
# plain version holder read/written by the workspace version tasks. It is NOT
# autoloaded (lib/sqa_demo is on the Zeitwerk ignore list in
# config/application.rb) precisely because Zeitwerk would otherwise expect a
# `Version` class here rather than a `VERSION` constant.
module SqaDemo
  module Rails
    VERSION = '0.3.0'
  end
end
