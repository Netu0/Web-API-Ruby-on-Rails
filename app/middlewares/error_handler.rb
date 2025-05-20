class ErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue => e
      error_response(e)
    end
  end

  private

  def error_response(exception)
    [
      500,
      { "Content-Type" => "application/json" },
      [
        {
          status: 500,
          erro: exception.message,
          timestamp: Time.now.utc
        }.to_json
      ]
    ]
  end
end
