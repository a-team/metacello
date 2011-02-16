require 'model'

class Project < Model
  DateTime.maglev_persistable
  Date.maglev_persistable
  Rational.maglev_persistable

  attr_accessor :name, :team, :urls, :description, :doIt, :screenshot,
    :updated_on, :license, :systems

  def initialize(name)
    self.name = name
    self.urls = []
    self.team = []
    self.systems = []
    self.screenshot = ""
    self.doIt = "(Installer ss project: 'MetacelloRepository')\n" +
          "\tinstall: ConfigurationOf#{name}.\n" +
          "ConfigurationOf#{name} project stableVersion load."
    self.license = "MIT"
  end

  def update_from(hash, who = nil)
    self.description = hash["description"]
    self.doIt = hash["doIt"]
    self.screenshot = hash["screenshot"]
    self.license = hash["license"]
    self.urls = (hash["urls"] || {}).sort_by {|a| a.first.to_i }.collect {|a| a.last }
    self.systems = (hash["systems"] || {}).sort_by {|a| a.first.to_i }.collect {|a| a.last }
    # self.updated_on = DateTime.now
    # The following prepends the current user (who did this update) to the team
    # list - calling uniq will leave the first occurence in the list
    self.team.unshift(who).uniq if who
    save
  end

  def team
    @team.collect(&:name).join(" ")
  end
end
