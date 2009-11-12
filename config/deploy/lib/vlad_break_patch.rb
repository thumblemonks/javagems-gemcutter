Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

# Monkey patches in a fix for the fact vlad used break where it should have used next
remove_task 'vlad:migrate'
remote_task 'vlad:migrate', :roles => :app do
  next unless target_host == Rake::RemoteTask.hosts_for(:app).first

  directory = case migrate_target.to_sym
              when :current then current_path
              when :latest  then current_release
              else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
              end

  run "cd #{current_path}; #{rake_cmd} RAILS_ENV=#{rails_env} db:migrate #{migrate_args}"
end
