default['jenkins']['slave'].tap do |slave|
  #
  # The username of the user who will own and run the Jenkins process. You can
  # change this to any user on the system. Chef will automatically create the
  # user if it does not exist.
  #
  #   node.normal['jenkins']['slave']['user'] = 'root'
  #
  slave['user'] = 'jenkins'

  #
  # The group under which Jenkins is running. Jenkins doesn't actually use or
  # honor this attribute - it is used for file permission purposes.
  #
  slave['group'] = 'jenkins'

  #
  # Jenkins user/group should be created as `system` accounts for `war` install.
  # The default of `true` will ensure that **new** jenkins user accounts are
  # created in the system ID range, existing users will not be modified.
  #
  #   node.normal['jenkins']['slave']['use_system_accounts'] = false
  #
  slave['use_system_accounts'] = true

    #
  # The path to the Jenkins home location. This will also become the value of
  # +$JENKINS_HOME+. By default, this is the directory where Jenkins stores its
  # configuration and build artifacts. You should ensure this directory resides
  # on a volume with adequate disk space.
  #
  slave['home'] = '/var/lib/jenkins'

  #
  # The directory where Jenkins should write its logfile(s). **This attribute
  # is only used by the package installer!**. The log directory will be owned
  # by the same user and group as the home directory. If you need furthor
  # customization, you should override these values in your wrapper cookbook.
  #
  #   node.normal['jenkins']['slave']['log_directory'] = '/var/log/jenkins'
  #
  slave['log_directory'] = '/var/log/jenkins'
end