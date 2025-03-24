module SanitizerResponse
  def sanitizer_response(object)
    object.as_json(
      except: [ :created_at, :updated_at ]
      )
  end
end