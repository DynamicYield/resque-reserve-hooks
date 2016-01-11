Resque::Plugin.module_eval do
  def before_reserve_hooks(job)
    job.methods.grep(/^before_reserve/).sort
  end

  def after_reserve_hooks(job)
    job.methods.grep(/^after_reserve/).sort
  end
end
