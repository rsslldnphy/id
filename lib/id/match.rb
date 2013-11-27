class Id::Match

  def initialize(model)
    @_model = model
  end

  def _evaluate
    yield self
    _result or fail BadMatchError, _model
  end

  def model(match = {}, &block)
    @_result ||= _model.instance_eval(&block) if _model === match
  end

  def _(&block)
    @_result ||= _model.instance_eval(&block)
  end

  private
  attr_reader :_model, :_result

  def method_missing(name, *args, &block)
    model(*args, &block) if name.to_s.titlecase == _model.class.name
  end
end

class BadMatchError < StandardError
  def initialize(value)
    super "No match for value: #{value.inspect}"
  end
end
