require 'spec_helper'

valid_public_key = <<-'DOC'
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1maGriV5zpEqPHT9lsdA
x+dHXnGLq79G8s7yYAdMRZOYUp4niEJszkerfgHcDksmaBnNvXM1PiMEbyLWlgnB
GnMuQqwEWC6HqkLKkf0LtWdg5pZrDjzt+fYdOPpvAyquZaEUmREpSCYRTEdhjBU5
KEJClWbFcTe0tuXO7uyP1ekX0UL2GxUYpbSzU728MEYt7URCKH5wPpwDKStOB4yL
IJR/UkW91Ro5WcczGzXolR/eOdHn65DZHxBIv3Dn54ydVEPRpiz2ClwzAqXpUZiI
KlBIW2RiGHAR8q4HWJYk0mZgqdpk4nRVEX/z4g8pG9L+/XwqGuPmLRk+LZOnofi5
ZQIDAQAB
-----END PUBLIC KEY-----
DOC
valid_rsa_key = <<-'DOC'
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA1maGriV5zpEqPHT9lsdAx+dHXnGLq79G8s7yYAdMRZOYUp4n
iEJszkerfgHcDksmaBnNvXM1PiMEbyLWlgnBGnMuQqwEWC6HqkLKkf0LtWdg5pZr
Djzt+fYdOPpvAyquZaEUmREpSCYRTEdhjBU5KEJClWbFcTe0tuXO7uyP1ekX0UL2
GxUYpbSzU728MEYt7URCKH5wPpwDKStOB4yLIJR/UkW91Ro5WcczGzXolR/eOdHn
65DZHxBIv3Dn54ydVEPRpiz2ClwzAqXpUZiIKlBIW2RiGHAR8q4HWJYk0mZgqdpk
4nRVEX/z4g8pG9L+/XwqGuPmLRk+LZOnofi5ZQIDAQABAoIBAGXpdjtxNOUru5fh
RGlXbUOYfCQ4dNu+oErqc+uRjH/GGLGs2725VV74UlwjJiblMexp15ImITjYDFOH
i9jl6hRYi7TFb4s7EuGrvf6G+fnQmg8BkQHDlJsskddzszEeKKfGWbQopCbXcYGA
rK2ZqQGp/Vxm7ZNTl2MY+bQ4Xmae9yL29xn0789kBEJSfoKyoIM0OlhjHxU6NZn9
assEjDesR8ftNUr50ejWihq3MlACN9EH6sUaphgvdzQe5ubnXlVnJp/Vq13GISvK
7WA2Slvu15hEhERmpaQ8bEnXF95LzdNfdcRoLPv3Fn4QbejE2MjuYNdtRLdhRRq4
3tIVlgECgYEA7epw+5O8vLHSfYGLsMoJVCXdkTTR5e0x8DVKuqLinaxJg0aNR5XX
sWDXEqFqnEAlSct5CM4Z+OOF/tA9Sq0vwSRBRPwZq7qdKJuxu+NtVVmB9J8tTOWZ
OJnfAAxNzaWZibWQ4UxuIW0E0gnL4Wkt9CiaeTFC8IVIjkNKwvhSN5kCgYEA5rKB
S8dHcu1HKQPXUEEmVyrDq7hlNuNqxiGb5tEDJV29P7nDytsTfD+bbUCWd0SjNbxR
zk9AnMIAwt7Y7k5c0Stc6W9VEmcBtjyENX2nXUROGdLcyBNTJpH8x979xl3QSkXU
avd4lOgpddIoW97uqSgvDhZZVRMwTh+vHA8ev60CgYAuJsE9/B2rmO8VC5E2fSqs
GSBO76kb6hQ63YuegsRlA6vK/F+hmE6cCQYPhiJxJvxUwVS8QYbGQhSXJnwNRWUz
GT5UDHdKWcvsua8TnH10BgXwlwQpm4xKb4bTso9RKiOLlB4DpljiwQwjVmUnV8jj
SREWG1k54RD/D8yr35HLWQKBgBXNtS6mTPhtuJYFyOnK3obKgefO67H+WG8Vahis
lHGJpINLWVfo0LSjhlsTCaWIFSzU+Z5YGzE1nMDOMw6C1X7nbEabwRyWI7FHku9D
SvgjpoYGSduXB/rTPWLejnmbED6Uzvi1Hu5j6tc535qfPUs7gwb/0b2arKwVjoVG
YI+ZAoGAJfM/7xexkmJGnYzgY9BR5q2k6NVdGuFQ/+VRt8oyc6/QGZl9f9Xijy9z
FpyCrkG2z72yOhA4TWzzOHZwROxdJl8yQYUlefvVRMijlDSlCN9gFoqEylqWZkJp
lhoe/qnm6k5+qBFoLA9rYALmSPJL09syh1c+lSvmFhXIMal2NcU=
-----END RSA PRIVATE KEY-----
DOC
another_valid_rsa_key = <<-'DOC'
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAoISxYJBTPAeAzFnm+lE/ljLlmGal2Xr3vwZKkvJiuKA/m4QJ
0ZNdtkBSDOVuG2dXVv6W4sChRtsCdvuVe7bjTYvlU8TWM3VEJDL9l9cRXScxxlKQ
Xwb35y1yV35NJfaK/jzm9KcErtQQs1RxvGlWRaohmLM8uQcuhjZfMsSlQoHQD5LX
sbPtk82RPyxYc1dj2vsaoi1VvuP2+jv4xLQOmNJY1bT5GTurqiltmxEtWhNNmGg0
2wtK00ifqLVO5HNc3gXQCDM2M99Sbmn1YtbrgsU9xMYfcPmvQvb+YoKskyoqck+c
HR//hi7vslbxABrny15LBkEfRc4TickphSGYXwIDAQABAoIBAATEzGw8/WwMIQRx
K06GeWgh7PZBHm4+m/ud2TtSXiJ0CE+7dXs3cJJIiOd/LW08/bhE6gCkjmYHfaRB
Ryicv1X/cPmzIFX5BuQ4a5ZGOmrVDkKBE27vSxAgJoR46RvWnjx9XLMp/xaekDxz
psldK8X4DvV1ZbltgDFWji947hvyqUtHdKnkQnc5j7aCIFJf9GMfzaeeDPMaL8WF
mVL4iy9EAOjNOHBshZj/OHyU5FbJ8ROwZQlCOiLCdFegftSIXt8EYDnjB3BdsALH
N6hquqrD7xDKyRbTD0K7lqxUubuMwTQpi61jZD8TBTXEPyFVAnoMpXkc0Y+np40A
YiIsR+kCgYEAyrc4Bh6fb9gt49IXGXOSRZ5i5+TmJho4kzIONrJ7Ndclwx9wzHfh
eGBodWaw5CxxQGMf4vEiaZrpAiSFeDffBLR+Wa2TFE5aWkdYkR34maDjO00m4PE1
S+YsZoGw7rGmmj+KS4qv2T26FEHtUI+F31RC1FPohLsQ22Jbn1ORipsCgYEAyrYB
J2Ncf2DlX1C0GfxyUHQOTNl0V5gpGvpbZ0WmWksumYz2kSGOAJkxuDKd9mKVlAcz
czmN+OOetuHTNqds2JJKKJy6hJbgCdd9aho3dId5Xs4oh4YwuFQiG8R/bJZfTlXo
99Qr02L7MmDWYLmrR3BA/93UPeorHPtjqSaYU40CgYEAtmGfWwokIglaSDVVqQVs
3YwBqmcrla5TpkMLvLRZ2/fktqfL4Xod9iKu+Klajv9ZKTfFkXWno2HHL7FSD/Yc
hWwqnV5oDIXuDnlQOse/SeERb+IbD5iUfePpoJQgbrCQlwiB0TNGwOojR2SFMczf
Ai4aLlQLx5dSND9K9Y7HS+8CgYEAixlHQ2r4LuQjoTs0ytwi6TgqE+vn3K+qDTwc
eoods7oBWRaUn1RCKAD3UClToZ1WfMRQNtIYrOAsqdveXpOWqioAP0wE5TTOuZIo
GiWxRgIsc7TNtOmNBv+chCdbNP0emxdyjJUIGb7DFnfCw47EjHnn8Guc13uXaATN
B2ZXgoUCgYAGa13P0ggUf5BMJpBd8S08jKRyvZb1CDXcUCuGtk2yEx45ern9U5WY
zJ13E5z9MKKO8nkGBqrRfjJa8Xhxk4HKNFuzHEet5lvNE7IKCF4YQRb0ZBhnb/78
+4ZKjFki1RrWRNSw9TdvrK6qaDKgTtCTtfRVXAYQXUgq7lSFOTtL3A==
-----END RSA PRIVATE KEY-----
DOC

describe 'stdlib::ssl::validate_key_pair' do
  context 'Valid test' do
    [
      ['good pair', valid_public_key, valid_rsa_key, true],
      ['wrong key', valid_public_key, another_valid_rsa_key, false],
    ].each do |name, cert, key, result|
      it "run test #{name}" do
        puts
        is_expected.to run.with_params(cert, key).and_return(result)
      end
    end
  end
  context 'failing test' do
    [
      ['prepended key', valid_public_key, valid_rsa_key.gsub(%r{^}, '  '), %r{Not a valid Private key}],
      ['bad key', valid_public_key, 'x' * 513, %r{Not a valid Private key}],
      ['prepended cert', valid_public_key.gsub(%r{^}, '  '), valid_rsa_key, %r{Not a valid Public key}],
      ['bad key', 'x' * 513, valid_rsa_key, %r{Not a valid Public key}],
      ['params wrong order', valid_rsa_key, valid_public_key, %r{public_key is private}],
    ].each do |name, cert, key, error|
      it "#{name}: shoulr raise #{error}" do
        is_expected.to run.with_params(cert, key).and_raise_error(Puppet::ParseError, error)
      end
    end
  end
end
