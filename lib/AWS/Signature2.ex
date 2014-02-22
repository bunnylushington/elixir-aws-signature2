defmodule AWS.Signature2 do

  def secret_key do
    System.get_env("AWS_SECRET_KEY")
  end

end