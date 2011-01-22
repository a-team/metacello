require 'model'

class Project < Model
  attr_accessor :name, :team, :urls, :description, :doIt, :screenshot,
    :updated_on, :license, :compatibility

  def initialize(name)
    self.name = name
    self.urls = []
    self.team = []
    self.compatibility = {}
    self.doIt = "(Installer ss project: 'MetacelloRepository')\n" +
          "\tinstall: ConfigurationOf#{name}.\n" +
          "ConfigurationOf#{name} project stableVersion load."
    save
  end

  def update_from(hash)
    ["name", "urls", "description", "doIt", "screenshot", "license"].each do |option|
      self.send(:"#{option}=", hash[option])
    end
    self.updated_on = Date.today
    # The following prepends the current user (who did this update) to the team
    # list - calling uniq will leave the first occurence in the list
    self.team.unshift(current_user).uniq
    save
  end

  def team
    @team.collect(&:name).join(" ")
  end
end
