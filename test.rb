require 'rubygems'
require 'jira-ruby'

options = {
  :username     => 'nattee',
  :password     => 'iwanyimh',
  :site         => 'https://cpjira.nattee.net/',
  :context_path => '',
  :auth_type    => :basic,
}

client = JIRA::Client.new(options)

project = client.Project.find('DK2')

project.issues.each do |issue|
  puts "#{issue.id} - #{issue.summary}"
end
