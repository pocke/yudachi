module Yudachi
  class Runner
    def run(app_id:, location_name:, notifier:)
      client = Client.new(app_id: app_id)

      location_name, geo = client.location_name_and_coodinated_geometry(location_name)
      raise "geometry not found" unless geo
      datapoints = client.rainfall(geo)
      raise "something wrong" unless datapoints

      observation_threshold = Time.now - 30 * 60
      datapoints = datapoints.select do |data|
        # Drop too old data
        data['Date'] > observation_threshold
      end

      if beginning_of_rainfall?(datapoints)
        notifier.notify(datapoints: datapoints, location_name: location_name)
      end
    end

    private def beginning_of_rainfall?(datapoints)
      # For debug
      # datapoints.select { |data| data["Type"] == 'forecast'}.each do |data|
      #   data['Rainfall'] = rand(1.0..20.0)
      # end

      # Already raining
      if datapoints.select { |data| data['Type'] == 'observation' }.any? { |data| data["Rainfall"] >= RAINFALL_THRESHOLD }
        return false
      end

      datapoints.select { |data| data['Type'] == 'forecast' }.any? { |data| data['Rainfall'] >= RAINFALL_THRESHOLD }
    end
  end
end
