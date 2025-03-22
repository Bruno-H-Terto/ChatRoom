class ApplicationController < ActionController::API
  include Authenticable

  private

  def sanitizer_response(object)
    object.as_json(
      except: [:created_at, :updated_at]
      )
  end
end
