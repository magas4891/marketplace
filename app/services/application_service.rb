# frozen_string_literal: true

class ApplicationService
  def initialize(params = {})
    @params = params
  end

  def self.perform(params = {}, &block)
    new(params).call(&block)
  end

  private

  attr_reader :params
end
