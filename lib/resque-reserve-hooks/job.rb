require 'resque-loner/legacy_helpers'

module Resque
  class Job
    extend Resque::Plugins::Loner::LegacyHelpers

    def self.get_args_from_payload payload
      if constantize(payload['class']).instance_variable_get(:@__is_throttled_job)
        payload['args'][1 .. -1]
      else
        payload['args']
      end
    end

    def before_reserve_hooks
      @before_reserve_hooks ||= Plugin.before_reserve_hooks(payload_class)
    end

    def after_reserve_hooks
      @after_reserve_hooks ||= Plugin.after_reserve_hooks(payload_class)
    end

    def self.reserve_with_reserve_hooks(queue)
      return unless payload = Resque.pop(queue)
      job = new(queue, payload)
      job_args = job.args || []
      # run before_ hooks
      can_reserve = job.before_reserve_hooks.all? do |hook|
        job.payload_class.send(hook, *job_args)
      end
      if can_reserve
        Resque::Plugins::Loner::Helpers.mark_loner_as_unqueued(queue, job) if job && !Resque.inline?
        # run after_ hooks
        job.after_reserve_hooks.all? do |hook|
          job.payload_class.send(hook, *job_args)
        end
        # perform job
        job
      else
        # requeue
        Resque.push(queue, class: job.payload_class.to_s, args: job_args)
        # don't perform
        nil
      end
    end

    class << self
      alias_method :reserve_without_reserve_hooks, :reserve
      alias_method :reserve, :reserve_with_reserve_hooks
    end
  end
end
