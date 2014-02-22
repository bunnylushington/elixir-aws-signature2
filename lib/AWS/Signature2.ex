defmodule AWS.Signature2 do

  def sign(url, params, method, access \\ nil, secret \\ nil, date \\ nil) do
    access = if access == nil, do: access_key, else: access
    secret = if secret == nil, do: secret_key, else: secret
    method = to_string(method) |> String.upcase
    uri_info = URI.parse url
    ts = if date == nil, do: DateFmt.format!(Date.now, "{ISO}"), else: date
    qs = params_to_qs(params ++ 
                        [SignatureMethod: "HmacSHA256",
                         SignatureVersion: 2,
                         AWSAccessKeyID: access,
                         Version: "2009-03-31",
                         Timestamp: ts])
    message = Enum.join [method, uri_info.host, uri_info.path, qs], "\n"
    :base64.encode(:hmac.hmac256(secret, message))
  end
  
  def params_to_qs(params) do
    space = "%20"               # the AWS will not accept +, must be %20
    Regex.replace ~r/\+/, (Enum.sort(params) |> URI.encode_query), space
  end

  # -- Convenience:
  def secret_key, do: System.get_env("AWS_SECRET_KEY")
  def access_key, do: System.get_env("AWS_ACCESS_KEY")

end