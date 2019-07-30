require 'slack-notifier'

module Yudachi
  class SlackNotifier
    def initialize(url)
      @url = url
    end

    def notify(datapoints:, location_name:)
      n = Slack::Notifier.new(@url) do
        defaults username: 'Yudachi'
      end

      beginning_idx = datapoints.find_index { |data| data['Type'] == 'forecast' && data['Rainfall'] >= RAINFALL_THRESHOLD }
      beginning = datapoints[beginning_idx]
      title = "#{location_name} で#{beginning["Date"].strftime("%H時%M分")}から雨が降り出しそうです！"
      graph = datapoints[beginning_idx..].map { |data| data['Date'].strftime('%H:%M: ') + 'x' * data['Rainfall'].ceil }.join("\n")

      n.ping attachments: [
        { title: title, text: graph, color: 'danger' },
      ]
    end
  end
end
