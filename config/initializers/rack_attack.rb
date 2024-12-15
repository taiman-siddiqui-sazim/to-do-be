class Rack::Attack

    throttle("requests/ip", limit: 100, period: 1.minute) do |req|
      req.ip
    end
  
    self.throttled_responder = lambda do |_env|
      [429, { "Content-Type" => "application/json" }, [{ error: "Rate limit exceeded" }.to_json]]
    end
  end
  