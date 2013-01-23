# Delayed::Job.destroy_failed_jobs = false
#   silence_warnings do
#     Delayed::Job.const_set("MAX_ATTEMPTS", 2)
#     Delayed::Job.const_set("MAX_RUN_TIME", 10.minutes)
#   end
Delayed::Worker.max_attempts = 2