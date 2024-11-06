class ExternalDbObject < ActiveRecord::Base
  self.abstract_class = true
  begin
    if %w[development test].include? Rails.env
      establish_connection(
          :adapter => EXTERNAL_DATABASE ["adapter"],
          :pool => EXTERNAL_DATABASE ["pool"],
          :timeout => EXTERNAL_DATABASE ["timeout"],
          :host => EXTERNAL_DATABASE ["host"],
          :database => EXTERNAL_DATABASE ["database"],
          :username => EXTERNAL_DATABASE ["username"],
          :password => EXTERNAL_DATABASE ["password"],
          :encoding => EXTERNAL_DATABASE ["encoding"])
    end
  rescue Exception => e
    Rails.logger.error("Failed to connect to #{EXTERNAL_DATABASE ["adapter"]}")
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("n"))
  end
end