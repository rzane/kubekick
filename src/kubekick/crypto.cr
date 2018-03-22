require "base64"
require "cox"

module Kubekick
  module Crypto
    PATTERN = /\AEJ\[(\d):([A-Za-z0-9+=\/]{44}):([A-Za-z0-9+=\/]{32}):(.+)\]\z/

    class InvalidBoxError < Exception
    end

    def self.encrypt(message, public, secret)
      nonce, enc = Cox.encrypt(
        message,
        Cox::PublicKey.new(public.hexbytes),
        Cox::SecretKey.new(secret.hexbytes)
      )

      parts = [
        "1",
        Base64.encode(public.hexbytes).rstrip,
        Base64.encode(nonce.bytes).rstrip,
        Base64.encode(enc).rstrip
      ]

      %(EJ[#{parts.join(":")}])
    end

    def self.decrypt(box, secret)
      matches = box.match(PATTERN)

      if matches.nil?
        raise InvalidBoxError.new("Invalid box '#{box}'")
      end

      result = Cox.decrypt(
        Base64.decode(matches[4]),
        Cox::Nonce.new(Base64.decode(matches[3])),
        Cox::PublicKey.new(Base64.decode(matches[2])),
        Cox::SecretKey.new(secret.hexbytes)
      )

      String.new(result)
    end
  end
end
