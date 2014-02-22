defmodule AWS.Signature2 do

  def sign(url, params, access \\ nil, secret \\ nil) do
    access = if access == nil, do: access_key, else: access
    secret = if secret == nil, do: secret_key, else: secret

    date = Date.now
    added_params = [Timestamp: DateFmt.format!(date, "{ISO}"),
                    SignatureMethod: "HmacSHA256",
                    SignatureVersion: 2,
                    Version: "2009-03-31",
                   ]
    query_string = params_to_query_string(params ++ added_params)
  end
  
  def params_to_query_string(params) do
    space = "%20"               # the AWS will not accept +, must be %20
    Regex.replace ~r/\+/, (Enum.sort(params) |> URI.encode_query), space
  end

  # -- Convenience:
  def secret_key, do: System.get_env("AWS_SECRET_KEY")
  def access_key, do: System.get_env("AWS_ACCESS_KEY")

end