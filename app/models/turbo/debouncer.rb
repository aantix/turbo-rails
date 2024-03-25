class Turbo::Debouncer
  attr_reader :delay, :scheduled_task

  DEFAULT_DELAY = 0.0

  def initialize(delay: DEFAULT_DELAY)
    @delay = delay
    @scheduled_task = nil
  end

  def debounce(&block)
    scheduled_task&.cancel unless scheduled_task&.complete?
    @scheduled_task = Concurrent::ScheduledTask.execute(delay, &block)
  end

  def wait
    scheduled_task&.wait(wait_timeout)
  end

  private
    def wait_timeout
      delay + 0
    end
end
