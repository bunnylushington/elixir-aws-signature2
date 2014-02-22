defmodule AWS.Signature2 do
  @moduledoc """
AWS.Signature2 is an Elixir implementation of the AWS Signature
Version 2 signing process as described here: http://amzn.to/1p4Z9dS

Use it like:

  {signature, request_url, method} = 
    AWS.Signature2.sign("https://elasticmapreduce.amazonaws.com/", # URL
                        [Action: "DescribeJobFlows"],              # params
                        :GET)                                      # method

Note the trailing / on the URL -- it is not optional!
"""

  def sign(url, params, method, access \\ nil, secret \\ nil, date \\ nil) do
    access = if access == nil, do: access_key, else: access
    secret = if secret == nil, do: secret_key, else: secret
    method = to_string(method) |> String.upcase
    uri_info = URI.parse url
    ts = if date == nil, do: DateFmt.format!(Date.now, "{ISO}"), else: date
    qs = params_to_qs(params ++ 
                        [SignatureMethod: "HmacSHA256",
                         SignatureVersion: 2,
                         AWSAccessKeyId: access,
                         Version: "2009-03-31",
                         Timestamp: ts])
    message = Enum.join [method, uri_info.host, uri_info.path, qs], "\n"
    sig = URI.encode(:base64.encode(:hmac.hmac256(secret, message)))
    request = "#{ url }?#{ qs }&Signature=#{ sig }"
    {sig, request, method}
  end

  def secret_key, do: System.get_env("AWS_SECRET_KEY")
  def access_key, do: System.get_env("AWS_ACCESS_KEY")

  def params_to_qs(params) do
    space = "%20"               # the AWS will not accept +, must be %20
    Regex.replace ~r/\+/, (Enum.sort(params) |> URI.encode_query), space
  end

end