module Yudachi
  class CLI
    def initialize
      @runner = Runner.new
    end

    def run
      notifier = SlackNotifier.new(slack_url)
      Runner.new.run(app_id: app_id, location_name: location_name, notifier: notifier)
    end

    def app_id
      ENV.fetch('YUDACHI_YAHOO_JAPAN_APP_ID')
    end

    def location_name
      ENV.fetch('YUDACHI_LOCATION')
    end

    def slack_url
      ENV.fetch('YUDACHI_SLACK_URL')
    end
  end
end
