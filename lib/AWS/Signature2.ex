defmodule AWS.Signature2 do

  def sign(url, params, access \\ nil, secret \\ nil) do
    access = if access == nil, do: access_key, else: access
    secret = if secret == nil, do: secret_key, else: secret

    date = Date.now
    added_params = [Timestamp: DateFmt.format!(date, "{ISO}"),
                    SignatureMethod: "HmacSHA256",
                    SignatureVersion: 2,
                    
                   ]
                                       

  end
  
  # -- Convenience:
  def secret_key, do: System.get_env("AWS_SECRET_KEY")
  def access_key, do: System.get_env("AWS_ACCESS_KEY")

  # -- Utility:
  def atom_to_parameter(a), do: to_string a

end