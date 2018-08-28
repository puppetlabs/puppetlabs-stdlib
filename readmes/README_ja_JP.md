# stdlib

#### 目次

1. [説明 - モジュールの機能とその有益性](#module-description)
1. [セットアップ - stdlib導入の基本](#setup)
1. [使用方法 - 設定オプションと追加機能](#usage)
1. [参考 - モジュールの機能と動作について](#reference)
    1. [クラス](#classes)
    1. [定義できるタイプ](#defined-types)
    1. [データタイプ](#data-types)
    1. [Facts](#facts)
    1. [関数](#functions)
1. [制約事項 - OSの互換性など](#limitations)
1. [開発 - モジュール貢献についてのガイド](#development)
1. [コントリビュータ](#contributors)


## モジュールの概要

このモジュールでは、Puppetモジュールリソースの標準ライブラリを提供しています。Puppetモジュールでは、この標準ライブラリを広く使用しています。stdlibモジュールは、以下のリソースをPuppetに追加します。

 * ステージ
 * Facts
 * 関数
 * 定義された型
 * データタイプ
 * プロバイダ

> *注:* バージョン3.7のPuppet Enterpriseには、stdlibモジュールが含まれていません。Puppet Enterpriseを使用している場合は、Puppetと互換性のあるstdlibの最新リリースをインストールする必要があります。

## セットアップ

stdlibモジュールを[インストール](https://puppet.com/docs/puppet/latest/modules_installing.html)し、この標準ライブラリの関数、Facts、リソースをPuppetに追加します。

stdlibに依存するモジュールを記述する場合は、必ずmetadata.jsonで[依存関係を特定](https://puppet.com/docs/puppet/latest/modules_metadata.html#specifying-dependencies-in-modules)してください。

## 使用方法

stdlibのほとんどの機能は、Puppetに自動的にロードされます。Puppetで標準化されたランステージを使用するには、`include stdlib`を用いてマニフェスト内でこのクラスを宣言してください。

宣言すると、stdlibがモジュール内の他のすべてのクラスを宣言します。現在モジュールに含まれている他のクラスは、`stdlib::stages`のみです。

`stdlib::stages`クラスは、インフラストラクチャ、言語ランタイム、アプリケーションレイヤの配備に関する各種のランステージを宣言します。ハイレベルステージは、以下のとおりです(順番どおり)。

  * セットアップ
  * main
  * runtime
  * setup_infra
  * deploy_infra
  * setup_app
  * deploy_app
  * deploy

使用例:

```puppet
node default {
  include stdlib
  class { java: stage => 'runtime' }
}
```

## リファレンス

* [パブリッククラス](#public-classes)
* [プライベートクラス](#private-classes)
* [定義された型](#defined-types)
* [データタイプ](#data-types)
* [Facts](#facts)
* [関数](#functions)

### クラス

#### パブリッククラス

`stdlib`クラスにはパラメータはありません。

#### プライベートクラス

* `stdlib::stages`: Puppetのランステージの標準セットを管理します。

### 定義された型

#### `file_line`

任意の行がファイル内に確実に含まれるようにします。最初と最後の空白を含め、行全体をマッチさせます。その行が与えられたファイルに含まれない場合は、Puppetがファイルの最後にその行を追加し、望ましい状態を確保します。1つのファイル内で複数のリソースを宣言し、複数の行を管理することが可能です。

例:

```puppet
file_line { 'sudo_rule':
  path => '/etc/sudoers',
  line => '%sudo ALL=(ALL) ALL',
}

file_line { 'sudo_rule_nopw':
  path => '/etc/sudoers',
  line => '%sudonopw ALL=(ALL) NOPASSWD: ALL',
}
```

上の例では、指定された両方の行が、ファイル `/etc/sudoers`に確実に含まれます。

マッチ例:

```puppet
file_line { 'bashrc_proxy':
  ensure => present,
  path   => '/etc/bashrc',
  line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
  match  => '^export\ HTTP_PROXY\=',
}
```

上の例では、`match`により、'export'で始まり'HTTP_PROXY'と続く行が探され、その行が行内の値に置き換えられます。

マッチ例:

```puppet
file_line { 'bashrc_proxy':
  ensure             => present,
  path               => '/etc/bashrc',
  line               => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
  match              => '^export\ HTTP_PROXY\=',
  append_on_no_match => false,
}
```

このコードの例では、`match`によってexportで始まり'HTTP_PROXY'が続く行が検索され、その行が行内の値に置き換えられます。マッチするものが見つからない場合、ファイルは変更されません。

 `ensure => absent`の例:

`ensure => absent`を設定する場合に、このタイプの動作には2通りがあります。

1つは`match => ...`と`match_for_absence => true`の設定です。`match`により、'export'で始まり'HTTP_PROXY'と続く行が探され、その行が削除されます。複数の行がマッチし、`multiple => true`パラメータが設定されていない場合は、エラーが生じます。

この例で`line => ...`パラメータは承認されますが無視されます。

例:　

```puppet
file_line { 'bashrc_proxy':
  ensure            => absent,
  path              => '/etc/bashrc',
  match             => '^export\ HTTP_PROXY\=',
  match_for_absence => true,
}
```

`ensure => absent`を設定する場合のもう1つの動作は、`line => ...`の指定と一致なしです。行が存在しないことを確認した場合のデフォルトの動作では、マッチするすべての行を削除します。この動作を無効にすることはできません。

例:　

```puppet
file_line { 'bashrc_proxy':
  ensure => absent,
  path   => '/etc/bashrc',
  line   => 'export HTTP_PROXY=http://squid.puppetlabs.vm:3128',
}
```


エンコード例:

```puppet
file_line { "XScreenSaver":
  ensure   => present,
  path     => '/root/XScreenSaver'
  line     => "*lock: 10:00:00",
  match    => '^*lock:',
  encoding => "iso-8859-1",
}
```

ファイルにUTF-8に対応しない特殊文字が用いられていると、「Invalid byte sequence in UTF-8」(UTF-8で無効なバイト列)というエラーメッセージが表示されます。この場合は、ファイルエンコーディングを決定し、`encoding`属性で指定してください。

**Autorequire:** Puppetが管理しているファイルに、管理対象となる行が含まれている場合は、`file_line`リソースと当該ファイルの暗黙的な依存関係が設定されます。

**パラメータ**　

パラメータは、別途説明がない限り、すべてオプションです。

##### `after`

このパラメータで指定された行の後に、Puppetが正規表現を用いて新規の行を追加します(既存の行が規定の位置に追加されます)。

値: 正規表現を含む文字列

デフォルト値: `undef`。

##### `encoding`

適正なファイルエンコードを指定します。

値: 有効なRuby文字エンコードを指定する文字列

デフォルト: 'UTF-8'

##### `ensure`: リソースが存在するかどうかを指定します。

値: 'present'、'absent'

デフォルト値: 'present'。

##### `line`

**必須**

`path`パラメータにより位置を示されたファイルに追加する行を設定します。

値: 文字列

##### `match`

ファイル内の既存の行と比較する正規表現を指定します。マッチが見つかった場合、新規の行を追加する代わりに、置き換えられます。

値: 正規表現を含む文字列

デフォルト値: `undef`。


##### `match_for_absence`

`ensure => absent`の場合にマッチを適用するかどうかを指定します。`true`に設定してマッチを設定すると、マッチする行が削除されます。`false`に設定すると(デフォルト)、`ensure => absent`の場合にマッチが無視され、代わりに`line`の値が使用されます。`ensure => present`になっている場合は、このパラメータは無視されます。

ブーリアン。

デフォルト値: `false`。

##### `multiple`

`match`および`after`により複数の行を変更できるかどうかを指定します。`false`に設定すると、file_lineは1つの行のみ置き換えることができますが、複数の行を置き換えようとするとエラーが発生します。`true`に設定すると、file_lineは1つまたは複数の行を置き換えることができます。

値: `true`、`false`。

デフォルト値: `false`。


##### `name`

リソースの名称として使用する名前を指定します。リソースのnamevarをリソースの規定の`title`と異なるものにしたい場合は、`name`で名前を指定します。

値: 文字列

デフォルト値: タイトルの値

##### `path`

**必須**

`line`で指定された行を確保するファイルを指定します。

値: 当該ファイルの絶対パスを指定する文字列

##### `replace`

`match`パラメータとマッチする既存の行をリソースで上書きするかどうかを指定します。`false`に設定すると、`match`パラメータにマッチする行が見つかった場合、その行はファイルに配置されません。

`false`に設定すると、`match`パラメータにマッチする行が見つかった場合、その行はファイルに配置されません。

ブーリアン。

デフォルト値: `true`。

##### `replace_all_matches_not_matching_line`

`line`がファイルにすでに存在する場合でも、`match`パラメータに一致するすべての行が置き換えられます。

デフォルト値: `false`。

### データタイプ

#### `Stdlib::Absolutepath`

厳密な絶対パスタイプ。UnixpathタイプおよびWindowspathタイプの異形を使用します。

使用可能なインプット例:

```shell
/var/log
```

```shell
/usr2/username/bin:/usr/local/bin:/usr/bin:.
```

```shell
C:\\WINDOWS\\System32
```

使用不可能なインプット例:

```shell
../relative_path
```

#### `Stdlib::Ensure::Service`

サービスリソースの使用可能なensure値と一致します。

使用可能なインプット例:

```shell
stopped
running
```

使用不可能なインプット例:

```shell
true
false
```

#### `Stdlib::Httpsurl`

HTTPS URLに一致します。この一致では、大文字と小文字は区別されません。

使用可能なインプット例:

```shell
https://hello.com

HTTPS://HELLO.COM
```

使用不可能なインプット例:

```shell
httds://notquiteright.org`
```

#### `Stdlib::Httpurl`

HTTPSとHTTPの両方のURLに一致します。この一致では、大文字と小文字は区別されません。

使用可能なインプット例:

```shell
https://hello.com

http://hello.com

HTTP://HELLO.COM
```

使用不可能なインプット例:

```shell
httds://notquiteright.org
```

#### `Stdlib::MAC`

[RFC5342](https://tools.ietf.org/html/rfc5342)で定義されるMACアドレスに一致します。

#### `Stdlib::Unixpath`

Unixオペレーティングシステムの絶対パスに一致します。

使用可能なインプット例:

```shell
/usr2/username/bin:/usr/local/bin:/usr/bin:

/var/tmp
```

使用不可能なインプット例:

```shell
C:/whatever

some/path

../some/other/path
```

#### `Stdlib::Filemode`

1から4までの数字とシンボリックファイルモードからなる8進ファイルモードに一致します。

使用可能なインプット例:

```shell
0644
```

```shell
1777
```

```shell
a=Xr,g=w
```

使用不可能なインプット例:

```shell
x=r,a=wx
```

```shell
0999
```

#### `Stdlib::Windowspath`

Windowsオペレーティングシステムのパスに一致します。

使用可能なインプット例:

```shell
C:\\WINDOWS\\System32

C:\\

\\\\host\\windows
```

有効な値: Windowsのファイルパスに一致します。

#### `Stdlib::Filesource`

Puppetファイルタイプのソースパラメータの有効な値のパスに一致します。

使用可能なインプット例:

```shell
http://example.com

https://example.com

file:///hello/bla
```

有効な値: ファイルパス。

#### `Stdlib::Fqdn`

完全修飾ドメイン名(FQDN)のパスに一致します。

使用可能なインプット例:

```shell
localhost

example.com

www.example.com
```
有効な値: サーバーのドメイン名。

#### `Stdlib::Host`

有効なホストに一致します。これには、有効なipv4、ipv6、またはfqdnを含みます。

使用可能なインプット例:

```shell
localhost

www.example.com

192.0.2.1
```

有効な値: IPアドレスまたはドメイン名。

#### `Stdlib::Port`

有効なTCP/UDPポート番号に一致します。

使用可能なインプット例:

```shell
80

443

65000
```

有効な値: 整数。

#### `Stdlib::Port::Privileged`

有効なTCP/UDP特権ポート(1024未満)に一致します。

使用可能なインプット例:

```shell
80

443

1023
```

有効な値: 1024未満の数。

#### `Stdlib::Port::Unprivileged`

有効なTCP/UDP特権ポート(1024以上)に一致します。

使用可能なインプット例:

```shell
1024

1337

65000

```

有効な値: 1024以上の数。

#### `Stdlib::Base32`

有効なbase32文字列のパスに一致します。

使用可能なインプット例:

```shell
ASDASDDASD3453453

asdasddasd3453453=

ASDASDDASD3453453==
```

有効な値: base32文字列。

#### `Stdlib::Base64`

有効なbase64文字列のパスに一致します。

使用可能なインプット例:

```shell
asdasdASDSADA342386832/746+=

asdasdASDSADA34238683274/6+

asdasdASDSADA3423868327/46+==
```

有効な値: base64文字列。

#### `Stdlib::Ipv4`

有効なIPv4アドレスに一致します。

使用可能なインプット例:

```shell
0.0.0.0

192.0.2.1

127.0.0.1
```

有効な値: IPv4アドレス。

#### `Stdlib::Ipv6`

有効なIPv6アドレスに一致します。

使用可能なインプット例:

```shell
2001:0db8:85a3:0000:0000:8a2e:0370:7334

2001:db8::

2001:db8::80
```

有効な値: IPv6アドレス。

#### `Stdlib::Ip_address`

有効なIPv4またはIPv6アドレスに一致します。

使用可能なインプット例:

```shell
0.0.0.0

127.0.0.1

fe80:0000:0000:0000:0204:61ff:fe9d:f156
```

有効な値: IPアドレス。

#### `Stdlib::IP::Address`

IPv4とIPv6両方のアドレスを含む、任意のIPアドレスに一致します。CIDRフォーマットのIPv4アドレスで使用されるアドレスプレフィックスの有無に関わらず一致します。

例:

```
'127.0.0.1' =~ Stdlib::IP::Address                                # true
'10.1.240.4/24' =~ Stdlib::IP::Address                            # true
'52.10.10.141' =~ Stdlib::IP::Address                             # true
'192.168.1' =~ Stdlib::IP::Address                                # false
'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210' =~ Stdlib::IP::Address  # true
'FF01:0:0:0:0:0:0:101' =~ Stdlib::IP::Address                     # true
```

#### `Stdlib::IP::Address::V4`

CIDRプレフィックスの有無に関わらず、ドット区切りの4つの10進数で表現されたIPv4アドレスで構成される任意の文字列に一致します。省略形(192.168.1など)には一致しません。省略形はドキュメンテーションが不十分で、サポートにばらつきがあるためです。

例:

```
'127.0.0.1' =~ Stdlib::IP::Address::V4                                # true
'10.1.240.4/24' =~ Stdlib::IP::Address::V4                            # true
'192.168.1' =~ Stdlib::IP::Address::V4                                # false
'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210' =~ Stdlib::IP::Address::V4  # false
'12AB::CD30:192.168.0.1' =~ Stdlib::IP::Address::V4                   # false
```

有効な値: IPv4アドレス。

#### `Stdlib::IP::Address::V6`

アドレスプレフィックスの有無に関わらず、RFC 2373に規定された任意のフォーマットで記述されたIPv6アドレスを構成する任意の文字列に一致します。

例:

```
'127.0.0.1' =~ Stdlib::IP::Address::V6                                # false
'10.1.240.4/24' =~ Stdlib::IP::Address::V6                            # false
'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210' =~ Stdlib::IP::Address::V6  # true
'FF01:0:0:0:0:0:0:101' =~ Stdlib::IP::Address::V6                     # true
'FF01::101' =~ Stdlib::IP::Address::V6                                # true
```

有効な値: IPv6アドレス。

#### `Stdlib::IP::Address::Nosubnet`

`Stdlib::IP::Address`エイリアスと同じものに一致しますが、アドレスプレフィックスを含むアドレスには一致しません(たとえば、'192.168.0.6'には一致しますが、'192.168.0.6/24'には一致しません)。

有効な値: サブネットを持たないIPアドレス。

#### `Stdlib::IP::Address::V4::CIDR`

CIDR形式のIPv4アドレスに一致します。アドレスにアドレスプレフィックスが含まれている場合にのみ一致します(例えば、'192.168.0.6/24'には一致しますが、'192.168.0.6'には一致しません)。

有効な値: CIDRが提供されたIPv4アドレス、たとえば'192.186.8.101/105'など。これは、'192.186.8.101'～'192.168.8.105'を含むすべてに一致します。

#### `Stdlib::IP::Address::V4::Nosubnet`

アドレスプレフィックスを含まないIPv4アドレスに一致します(たとえば、'192.168.0.6'には一致しますが、'192.168.0.6/24'には一致しません)。

有効な値: サブネットを持たないIPv4アドレス。

#### `Stdlib::IP::Address::V6::Full`

[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.2に規定された「好ましい形式」のIPv6アドレスに一致します。[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.3に規定されたアドレスプレフィックスの有無に関わらず一致します。

#### `Stdlib::IP::Address::V6::Alternate`

[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.2に規定された「代替形式」(最後の2つの16ビット断片をドット区切りの4つの10進数で表現できる)のIPv6アドレスに一致します。[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.3に規定されたアドレスプレフィックスの有無に関わらず一致します。

#### `Stdlib::IP::Address::V6::Compressed`

[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.2に規定された0を圧縮する記法である`::`を含む可能性のあるIPv6アドレスに一致します。[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.3に規定されたアドレスプレフィックスの有無に関わらず一致します。

#### `Stdlib::IP::Address::V6::Nosubnet`

`Stdlib::IP::Address::V6::Nosubnet::Full`、`Stdlib::IP::Address::V6::Nosubnet::Alternate`、および`Stdlib::IP::Address::V6::Nosubnet::Compressed`を許可するエイリアス。

#### `Stdlib::IP::Address::V6::Nosubnet::Full`

[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.2.1に規定された「好ましい形式」のIPv6アドレスに一致します。[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.3に規定されたアドレスプレフィックスを持つアドレスには一致しません。

#### `Stdlib::IP::Address::V6::Nosubnet::Alternate`

[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.2.1に規定された「代替形式」(最後の2つの16ビット断片をドット区切りの4つの10進数で表現できる)のIPv6アドレスに一致します。[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.3に規定されたアドレスプレフィックスを持たないアドレスにのみ一致します。

#### `Stdlib::IP::Address::V6::Nosubnet::Compressed`

[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.2.2に規定された0を圧縮する記法である`::`を含む可能性のあるIPv6アドレスに一致します。[RFC 2373](https://www.ietf.org/rfc/rfc2373.txt)の2.3に規定されたアドレスプレフィックスを持たないアドレスにのみ一致します。

### Facts

#### `package_provider`

Puppetがこのシステムのパッケージ管理に使用するデフォルトのプロバイダを返します。

#### `is_pe`

Puppet Enterpriseがインストールされているかどうかを返します。PE 3.x以降のプラットフォームでは何も報告されません。

#### `pe_version`

インストールされているPuppet Enterpriseのバージョンを返します。PE 3.x以降のプラットフォームでは何も報告されません。

#### `pe_major_version`

インストールされているPuppet Enterpriseのメジャーバージョンを返します。PE 3.x以降のプラットフォームでは何も報告されません。

#### `pe_minor_version`

インストールされているPuppet Enterpriseのマイナーバージョンを返します。PE 3.x以降のプラットフォームでは何も報告されません。

#### `pe_patch_version`

インストールされているPuppet Enterpriseのパッチバージョンを返します。

#### `puppet_vardir`

PuppetまたはPuppet agentが稼働しているノードについて設定されたPuppet vardirの値を返します。

#### `puppet_environmentpath`

PuppetまたはPuppet agentが稼働しているノードについて設定されたPuppet環境の値を返します。

#### `puppet_server`

Puppet agentの`server`値を返します。この値は、agentが通信するPuppet masterのホストネームです。

#### `root_home`

ルートのホームディレクトリを決定します。

ルートのホームディレクトリを決定します。これは、オペレーティングシステムによって異なります。通常は'/root'です。

#### `service_provider`

Puppetがこのシステムのサービス管理に使用するデフォルトのプロバイダを返します。

### 関数

#### `abs`

**非推奨:** この関数は、Puppet 6.0.0で、内蔵の[`abs`](https://puppet.com/docs/puppet/latest/function.html#abs)関数に置き換えられました。

数字の絶対値を返します。たとえば、'-34.56'は'34.56'になります。

引数: 整数値または浮動小数点値のいずれかの単一の引数。

*タイプ*: 右辺値

#### `any2array`

任意のオブジェクトを、そのオブジェクトを含む配列に変換します。空の引数リストは空の配列に変換されます。ハッシュは、キーと値が交互になった配列に変換されます。配列は変換されません。

Puppet 5.0.0以降では、タイプシステムを使用してほとんどすべてのデータタイプの新しい値を作成できます。内蔵の[`Array.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-array-and-tuple)関数を使用して新しい配列を作成できます。

    $hsh = {'key' => 42, 'another-key' => 100}
    notice(Array($hsh))

`[['key', 42], ['another-key', 100]]`を通知します

配列のデータタイプには、"まだ配列でない場合は配列を作成する"という特別なモードもあります。

    notice(Array({'key' => 42, 'another-key' => 100}, true))

`true`フラグはハッシュが配列に変換されないようにするため、`[{'key' => 42, 'another-key' => 100}]`を通知します。

*タイプ*: 右辺値

#### `any2bool`

任意のオブジェクトをブーリアンに変換します。

* 'Y'、'y'、'1'、'T'、't'、'TRUE'、'yes'、'true'といった文字列は`true`を返します。
* '0'、'F'、'f'、'N'、'n'、'FALSE'、'no'、'false'といった文字列は`false`を返します。
* ブーリアンは元の値を返します。
* 0よりも大きい数字(または数字の文字列表現)は`true`を返します。それ以外は`false`を返します。
* undef値は`false`を返します。
* それ以外はすべて`true`を返します。

詳細については、内蔵の[`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean)を参照してください。

*タイプ*: 右辺値

#### `assert_private`

現在のクラスまたは定義をプライベートとして設定します。現在のモジュール外のクラスまたは定義タイプを呼び出すことはできません。

たとえば、クラス`foo::bar`で`assert_private()`がコールされると、クラスがモジュール`foo`の外から呼び出された場合、次のメッセージがアウトプットされます：`Class foo::bar is private`。

使用したいエラーメッセージを指定する方法:

```puppet
assert_private("You're not supposed to do that!")
```

*タイプ*: ステートメント

#### `base64`

文字列とbase64エンコードを相互に変換します。`action` ('encode'、'decode')とプレーンまたは base64でエンコードした`string`、およびオプションで`method` ('default'、'strict'、'urlsafe')が必要です。

下位互換性を得るには、`method`を`default`に設定します(指定されていない場合)。

> **注:** この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

Puppet 4.8.0以降では、ベース64 でエンコードされた文字列の生成に、`バイナリ`データタイプを使用できます。

詳細については、内蔵の[`String.new`](https://puppet.com/docs/puppet/latest/function.html#binary-value-to-string)関数と[`Binary.new`](https://puppet.com/docs/puppet/latest/function.html#creating-a-binary)関数を参照してください。

バイナリ(非UTF-8)コンテンツを含むファイルの読み取りについては、内蔵の[`binary_file`](https://puppet.com/docs/puppet/latest/function.html#binary_file)関数を参照してください。

    # encode a string as if it was binary
    $encodestring = String(Binary('thestring', '%s'))
    # decode a Binary assuming it is an UTF-8 String
    $decodestring = String(Binary("dGhlc3RyaW5n"), "%s")

**例:**

```puppet
base64('encode', 'hello')
base64('encode', 'hello', 'default')
# return: "aGVsbG8=\n"

base64('encode', 'hello', 'strict')
# return: "aGVsbG8="

base64('decode', 'aGVsbG8=')
base64('decode', 'aGVsbG8=\n')
base64('decode', 'aGVsbG8=', 'default')
base64('decode', 'aGVsbG8=\n', 'default')
base64('decode', 'aGVsbG8=', 'strict')
# return: "hello"

base64('encode', 'https://puppetlabs.com', 'urlsafe')
# return: "aHR0cHM6Ly9wdXBwZXRsYWJzLmNvbQ=="

base64('decode', 'aHR0cHM6Ly9wdXBwZXRsYWJzLmNvbQ==', 'urlsafe')
# return: "https://puppetlabs.com"
```

*タイプ*: 右辺値

#### `basename`

パスの`basename`を返します。オプションの引数で拡張子が外れます。例:

```puppet
basename('/path/to/a/file.ext')            => 'file.ext'
basename('relative/path/file.ext')         => 'file.ext'
basename('/path/to/a/file.ext', '.ext')    => 'file'
```

*タイプ*: 右辺値

#### `bool2num`

ブーリアンを数字に変換します。以下の値を変換します。

* `false`、'f'、'0'、'n'、'no'を0に変換します。
* `true`、't'、'1'、'y'、'yes'を1に変換します。

引数: インプットとして、単一のブーリアンまたは文字列。

Puppet 5.0.0以降では、 タイプシステムを使用しているほとんどすべてのデータタイプに関して値を作成できます。内蔵の[`Numeric.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-numeric)、 [`Integer.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-integer)、および[`Float.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-float)
の各関数を使用して数値に変換できます。

    notice(Integer(false)) # Notices 0
    notice(Float(true))    # Notices 1.0

*タイプ*: 右辺値

#### `bool2str`

オプションで提供される引数を用いて、ブーリアンを文字列に変換します。オプションの第2および第3の引数は、trueおよびfalseがそれぞれ何に変換されるかを表しています。与えられた引数が1つだけの場合は、ブーリアンから`true`または`false`を含む文字列に変換されます。

*例:*

```puppet
bool2str(true)                    => `true`
bool2str(true, 'yes', 'no')       => 'yes'
bool2str(false, 't', 'f')         => 'f'
```

引数: ブーリアン。

Since Puppet 5.0.0, you can create new values for almost any
data type using the type system — you can use the built-in
[`String.new`](https://puppet.com/docs/puppet/latest/function.html#boolean-to-string)
function to convert to String, with many different format options:

    notice(String(false))         # Notices 'false'
    notice(String(true))          # Notices 'true'
    notice(String(false, '%y'))   # Notices 'yes'
    notice(String(true, '%y'))    # Notices 'no'

*タイプ*: 右辺値

#### `camelcase`

**非推奨:**この関数は、Puppet 6.0.0で、内蔵の[`camelcase`](https://puppet.com/docs/puppet/latest/function.html#camelcase)関数に置き換えられました。

配列内の1つの文字列またはすべての文字列の大文字と小文字の別をCamelCase(大小文字混在)に変換します。

引数: 配列または文字列のいずれか。受け取ったものと同じタイプの引数を返しますが、CamelCaseの形式で返します。

*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

*タイプ*: 右辺値

#### `capitalize`

**非推奨:**この関数は、Puppet 6.0.0で、内蔵の[`capitalize`](https://puppet.com/docs/puppet/latest/function.html#capitalize)関数に置き換えられました。

文字列または複数文字列の配列の最初の文字を大文字にし、各文字列の残りの文字を小文字にします。

引数: インプットとして、単一文字列または配列。*タイプ*: 右辺値

*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `ceiling`

**非推奨:**この関数は、Puppet 6.0.0で、内蔵の[`ceiling`](https://puppet.com/docs/puppet/latest/function.html#ceiling)関数に置き換えられました。

引数以上の最小整数を返します。

引数: 単一の数値。

*タイプ*: 右辺値

#### `chomp`

**非推奨:**この関数は、Puppet 6.0.0で、内蔵の[`chomp`](https://puppet.com/docs/puppet/latest/function.html#chomp)関数に置き換えられました。

文字列または複数文字列の配列の最後から、レコード分離文字を削除します。たとえば、'hello\n'は'hello'になります。

引数: 単一の文字または配列。

*タイプ*: 右辺値

#### `chop`

**非推奨:**この関数は、Puppet 6.0.0で、内蔵の[`chop`](https://puppet.com/docs/puppet/latest/function.html#chop)関数に置き換えられました。

最後の文字を削除した新しい文字列を返します。文字列が'\r\n'で終わる場合は、両方の文字が削除されます。`chop`を空文字列に適用すると、空文字列が返されます。レコード分離文字のみを削除する場合は、`chomp`関数を使用してください。

引数: インプットとして、文字列または複数文字列の配列。

*タイプ*: 右辺値

#### `clamp`

整数値に基づく分類により、当該領域[Min、X、Max]内で値を維持します(パラメータの順序は関係ありません)。文字列が変換され、数字として比較されます。値の配列は、さらなる処理が可能なリストに平坦化されます。例:

  * `clamp('24', [575, 187])`は187を返します。
  * `clamp(16, 88, 661)`は88を返します。
  * `clamp([4, 3, '99'])`は4を返します。

引数: 文字列、配列、数字。

Puppet 6.0.0以降では、内蔵の関数を使用して同じ結果を得ることができます。

    [$minval, $maxval, $value_to_clamp].sort[1]

*タイプ*: 右辺値

#### `concat`

複数配列のコンテンツを、与えられた最初の配列に追加します。例:

  * `concat(['1','2','3'],'4')`は['1','2','3','4']を返します。
  * `concat(['1','2','3'],'4',['5','6','7'])`は['1','2','3','4','5','6','7']を返します。

Puppet 4.0以降では、配列の連結とハッシュのマージのために`+`演算子を使い、`<<`演算子を使って追加することができます。

    ['1','2','3'] + ['4','5','6'] + ['7','8','9'] # returns ['1','2','3','4','5','6','7','8','9']
    [1, 2, 3] << 4 # returns [1, 2, 3, 4]
    [1, 2, 3] << [4, 5] # returns [1, 2, 3, [4, 5]]

*タイプ*: 右辺値

#### `convert_base`

与えられた整数または整数を表す10進数文字列を、指定した基数の文字列に変換します。例:

  * `convert_base(5, 2)`は'101'になります。
  * `convert_base('254', '16')`は'fe'になります。

Puppet 4.5.0以降では、内蔵の[`String.new`](https://puppet.com/docs/puppet/latest/function.html#integer-to-string)関数を使って、さまざまな形式のオプションでこれを行うことができます。

    $binary_repr = String(5, '%b') # results in "101"
    $hex_repr = String(254, '%x')  # results in "fe"
    $hex_repr = String(254, '%#x') # results in "0xfe"

#### `count`

配列を最初の引数とオプションの2番目の引数と解釈します。
2番目の引数に等しい配列内の要素の数をカウントします。
配列のみで呼び出された場合は、nil/undef/empty-string以外の要素の数をカウントします。

> **注意**: 等値はRubyメソッドでテストされます。これはRubyが
等値とみなす対象になります。文字列の場合、等値は大文字と小文字を区別します。

Puppetコアでは、 内蔵の
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) (Puppet 4.0.0以降)および
[`length`](https://puppet.com/docs/puppet/latest/function.html#length) (Puppet 5.5.0以降、それ以前ではstdlib)の各関数の組み合わせを使用してカウントが行われます。

この例では、`undef`でない値のカウントを行う方法を示しています。

    notice([42, "hello", undef].filter |$x| { $x =~ NotUndef }.length)

2を通知します。

*タイプ*: 右辺値

#### `deep_merge`

2つ以上のハッシュを再帰的に統合し、その結果得られたハッシュを返します。

```puppet
$hash1 = {'one' => 1, 'two' => 2, 'three' => { 'four' => 4 } }
$hash2 = {'two' => 'dos', 'three' => { 'five' => 5 } }
$merged_hash = deep_merge($hash1, $hash2)
```

得られるハッシュは、以下に相当します。

```puppet
$merged_hash = { 'one' => 1, 'two' => 'dos', 'three' => { 'four' => 4, 'five' => 5 } }
```

ハッシュである重複キーが存在する場合は、そうした重複キーが再帰的に統合されます。ハッシュではない重複キーが存在する場合は、最右のハッシュのキーが上位になります。

*タイプ*: 右辺値

#### `defined_with_params`

属性のリソースリファレンスとオプションでハッシュを取得します。特定の属性を持つリソースがすでにカタログに追加されている場合は`true`を返します。そうでない場合は`false`を返します。

```puppet
user { 'dan':
  ensure => present,
}

if ! defined_with_params(User[dan], {'ensure' => 'present' }) {
  user { 'dan': ensure => present, }
}
```

*タイプ*: 右辺値

#### `delete`

配列から任意の要素のインスタンスを、文字列からサブストリングを、またはハッシュからキーをすべて削除します。

例:　

* `delete(['a','b','c','b'], 'b')`は['a','c']を返します。
* `delete('abracadabra', 'bra')`は'acada'を返します。
* `delete({'a' => 1,'b' => 2,'c' => 3},['b','c'])`は{'a'=> 1}を返します。
* `delete(['ab', 'b'], 'b')`は['ab']を返します。

Puppet 4.0.0以降では、マイナス(`-`)演算子によって、配列から値を削除し、ハッシュからキーを削除します。

    ['a', 'b', 'c', 'b'] - 'b'
    # would return ['a', 'c']

    {'a'=>1,'b'=>2,'c'=>3} - ['b','c'])
    # would return {'a' => '1'}

内蔵の
[`regsubst`](https://puppet.com/docs/puppet/latest/function.html#regsubst)関数で、文字列からグローバル削除を実行できます。

    'abracadabra'.regsubst(/bra/, '', 'G')
    #は、'acada'を返します。

通常、内蔵の
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) 関数によって、キーと値との組み合わせに基づき、配列とハッシュからエントリをフィルタリングできます。

*タイプ*: 右辺値

#### `delete_at`

決められたインデックス付き値を配列から削除します。

例: `delete_at(['a','b','c'], 1)`は['a','c']を返します。

Puppet 4以降では、内蔵の
[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter)関数を使って、これを行うことができます。

    ['a', 'b', 'c'].filter |$pos, $val | { $pos != 1 } # returns ['a', 'c']
    ['a', 'b', 'c', 'd'].filter |$pos, $val | { $pos % 2 != 0 } # returns ['b', 'd']

あるいは、配列の最初もしくは最後から、または両端から同時に削除したい場合は、スライス演算子`[ ]`を使用します。

    $array[0, -1] # すべての値と同じ
    $array[2, -1] # 最初の2つの要素を除くすべて
    $array[0, -3] # 最後の2つの要素を除くすべて

    $array[1, -2] # 最初と最後の要素を除くすべて


*タイプ*: 右辺値

#### `delete_regex`

提示された正規表現にマッチする任意の要素のインスタンスを、配列またはハッシュからすべて削除します。文字列は1アイテム配列として処理されます。

*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。


例

* `delete_regex(['a','b','c','b'], 'b')`は['a','c']を返します。
* `delete_regex({'a' => 1,'b' => 2,'c' => 3},['b','c'])`は{'a'=> 1}を返します。
* `delete_regex(['abf', 'ab', 'ac'], '^ab.*')`は['ac']を返します。
* `delete_regex(['ab', 'b'], 'b')`は['ab']を返します。

Puppet 4.0.0以降では、内蔵の[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter)関数で同等の処理を行います。

    ["aaa", "aba", "aca"].filter |$val| { $val !~ /b/ }
    # ['aaa', 'aca']を返します

*タイプ*: 右辺値

#### `delete_values`

任意の値のインスタンスをハッシュからすべて削除します。

例:　

* `delete_values({'a'=>'A','b'=>'B','c'=>'C','B'=>'D'}, 'B')`は{'a'=>'A','c'=>'C','B'=>'D'}を返します。

Puppet 4.0.0以降では、内蔵の[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter)関数で同等の処理を行います。

    $array.filter |$val| { $val != 'B' }
    $hash.filter |$key, $val| { $val != 'B' }

*タイプ*: 右辺値

#### `delete_undef_values`

`undef`値のインスタンスをアレイまたはハッシュからすべて削除します。

例:　

* `$hash = delete_undef_values({a=>'A', b=>'', c=>`undef`, d => false})`は{a => 'A', b => '', d => false}を返します。

Puppet 4.0.0以降では、内蔵の[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter)関数で同等の処理を行います。

    $array.filter |$val| { $val =~ NotUndef }
    $hash.filter |$key, $val| { $val =~ NotUndef }

*タイプ*: 右辺値

#### `deprecation`

非推奨警告をプリントし、任意のキーについて警告を一度記録します:

```puppet
deprecation(key, message)
```

引数:

* キーを指定する文字列: Puppetプロセスの継続期間中にメッセージの数を少なく抑えるために、1つのキーにつき1つのメッセージのみを記録します。
* メッセージを指定する文字列: 記録されるテキスト。

*タイプ*: ステートメント

**`deprecation`に影響を与える設定**

Puppetの他の設定は、stdlibの`deprecation`関数に影響を与えます。

* [`disable_warnings`](https://puppet.com/docs/puppet/latest/configuration.html#disablewarnings)
* [`max_deprecations`](https://puppet.com/docs/puppet/latest/configuration.html#maxdeprecations)
* [`strict`](https://puppet.com/docs/puppet/latest/configuration.html#strict):

    * `error`: 非推奨メッセージにより、ただちに機能しなくなります。
    * `off`: メッセージがアウトプットされません。
    * `warning`: すべての警告を記録します。これがデフォルト設定です。

* 環境変数`STDLIB_LOG_DEPRECATIONS`

  非推奨警告を記録するかどうかを指定します。これは特に、自動テストの際、移行の準備ができる前にログに情報が氾濫するのを避けるうえで役立ちます。

  この変数はブーリアンで、以下の効果があります:

  * `true`: 警告を記録します。
  * `false`: 警告は記録されません。
  * 値を設定しない場合: Puppet 4は警告を出しますが、Puppet 3は出しません。

#### `difference`

2つの配列の間の差異を返します。返される配列はオリジナル配列のコピーで、第2の配列にも見られるアイテムがあれば、それが取り除かれます。

例:　

* `difference(["a","b","c"],["b","c","d"])`は["a"]を返します。

Puppet 4以降では、Puppet言語のマイナス(`-`)演算子は同じことを行います。

    ['a', 'b', 'c'] - ['b', 'c', 'd']
    # ['a']を返します

*タイプ*: 右辺値

#### `dig`

**非推奨:**この関数は、Puppet 4.5.0で、内蔵の[`dig`](https://puppet.com/docs/puppet/latest/function.html#dig)関数に置き換えられました。下位互換性を得るには、[`dig44()`](#dig44)を使用するか、新しいバージョンを使用してください。

パスを含むキー配列を通じて、複数レイヤーのハッシュおよびアレイ内の値を探します。この関数は各パスコンポーネントにより構造内を移動し、パスの最後で値を返すよう試みます。

この関数では、必要とされるパス引数に加え、デフォルトの引数を使用できます。パスが正しくない場合や、値が見つからない場合、その他のエラーが生じた場合は、デフォルトの引数を返します。

```ruby
$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

$value = dig($data, ['a', 'b', 2])
# $value = 'b3'

# with all possible options
$value = dig($data, ['a', 'b', 2], 'not_found')
# $value = 'b3'

# using the default value
$value = dig($data, ['a', 'b', 'c', 'd'], 'not_found')
# $value = 'not_found'
```

1. **$data** 取り扱うデータ構造。
2. **['a', 'b', 2]** パス配列。
3. **'not_found'** デフォルト値。何も見つからない場合に返されます。

デフォルト値: `undef`。

*タイプ*: 右辺値

#### `dig44`

パスを含むキー配列を通じて、複数レイヤーのハッシュおよびアレイ内の値を探します。この関数は各パスコンポーネントにより構造内を移動し、パスの最後で値を返すよう試みます。

この関数では、必要とされるパス引数に加え、デフォルトの引数を使用できます。パスが正しくない場合や、値が見つからない場合、その他のエラーが生じた場合は、デフォルトの引数を返します。

```ruby
$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

$value = dig44($data, ['a', 'b', 2])
# $value = 'b3'

# with all possible options
$value = dig44($data, ['a', 'b', 2], 'not_found')
# $value = 'b3'

# using the default value
$value = dig44($data, ['a', 'b', 'c', 'd'], 'not_found')
# $value = 'not_found'
```

*タイプ*: 右辺値

1. **$data** 取り扱うデータ構造。
2. **['a', 'b', 2]** パス配列。
3. **'not_found'** デフォルト値。何も見つからない場合に返されます。
   (オプション、デフォルトは`undef`)

#### `dirname`

パスの`dirname`を返します。たとえば、`dirname('/path/to/a/file.ext')`は'/path/to/a'を返します。

*タイプ*: 右辺値

#### `dos2unix`

与えられた文字列のUnixバージョンを返します。クロスプラットフォームテンプレートでファイルリソースを使用する場合に非常に役立ちます。

```puppet
file { $config_file:
  ensure  => file,
  content => dos2unix(template('my_module/settings.conf.erb')),
}
```

[unix2dos](#unix2dos)も参照してください。

*タイプ*: 右辺値

#### `downcase`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`downcase`](https://puppet.com/docs/puppet/latest/function.html#downcase)関数に置き換えられました。

配列内の1つの文字列またはすべての文字列の大文字と小文字の別を、小文字に変換します。

*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

*タイプ*: 右辺値

#### `empty`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`empty`](https://puppet.com/docs/puppet/latest/function.html#empty)関数に置き換えられました。

引数が要素を含まない配列かハッシュ、または空文字列である場合に、`true`を返します。引数が数値の場合に`false`を返します。

*タイプ*: 右辺値

#### `enclose_ipv6`

IPアドレスの配列を取得し、ipv6アドレスを大括弧でくくります。

*タイプ*: 右辺値

#### `ensure_packages`

配列またはハッシュ内のパッケージのリストを取得し、すでに存在しない場合にのみ、それらをインストールします。オプションで、ハッシュを第2のパラメータとして取得し、第3の引数として`ensure_resource()`または `ensure_resources()`関数に渡します。

*タイプ*: ステートメント

配列の場合:

```puppet
ensure_packages(['ksh','openssl'], {'ensure' => 'present'})
```

ハッシュの場合:

```puppet
ensure_packages({'ksh' => { ensure => '20120801-1' } ,  'mypackage' => { source => '/tmp/myrpm-1.0.0.x86_64.rpm', provider => "rpm" }}, {'ensure' => 'present'})
```

#### `ensure_resource`

リソースタイプ、タイトル、リソースを記述する属性のハッシュを取得します。

```
user { 'dan':
  ensure => present,
}
```

この例では、すでに存在しない場合にのみリソースが作成されます:

  `ensure_resource('user', 'dan', {'ensure' => 'present' })`

リソースがすでに存在しているものの、指定されたパラメータとマッチしない場合は、リソースの再作成が試みられ、重複リソース定義エラーにつながります。

リソースの配列を提示することも可能です。それぞれのリソースは、すでに存在しない場合に、指定のタイプおよびパラメータにより作成されます。

`ensure_resource('user', ['dan','alex'], {'ensure' => 'present'})`

*タイプ*: ステートメント

#### `ensure_resources`

ハッシュからリソース宣言を作成しますが、すでに宣言されているリソースとは対立しません。

リソースタイプ、タイトル、リソースを記述する属性のハッシュを指定します。

```puppet
user { 'dan':
  gid => 'mygroup',
  ensure => present,
}

ensure_resources($user)
```

リソースのハッシュを提示します。リストにあるリソースは、すでに存在しない場合に、指定のタイプおよびパラメータにより作成されます。

    ensure_resources('user', {'dan' => { gid => 'mygroup', uid => '600' } ,  'alex' => { gid => 'mygroup' }}, {'ensure' => 'present'})

Hieraバックエンドから:

```yaml
userlist:
  dan:
    gid: 'mygroup'
    uid: '600'
  alex:
    gid: 'mygroup'
```

```puppet
ensure_resources('user', hiera_hash('userlist'), {'ensure' => 'present'})
```

#### `fact`

指定されたfactの値を返します。構造化されたfactを参照する場合にドット表記を使用することができます。指定されたfactが存在しない場合は、Undefを返します。

使用例:

```puppet
fact('kernel')
fact('osfamily')
fact('os.architecture')
```

配列のインデックス: 

```puppet
$first_processor  = fact('processors.models.0')
$second_processor = fact('processors.models.1')
```

名前に「.」を含むfact:

```puppet
fact('vmware."VRA.version"')
```

#### `flatten`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`flatten`](https://puppet.com/docs/puppet/latest/function.html#flatten)関数に置き換えられました。

ネストの深いアレイを平坦化し、結果として単一のフラット配列を返します。

たとえば、`flatten(['a', ['b', ['c']]])`は['a','b','c']を返します。

*タイプ*: 右辺値

#### `floor`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`floor`](https://puppet.com/docs/puppet/latest/function.html#floor)関数に置き換えられました。

引数以下の最大整数を返します。

引数: 単一の数値。

*タイプ*: 右辺値

#### `fqdn_rand_string`

ランダムな英数字文字列を生成します。`$fqdn` factとオプションのシードを組み合わせると、反復的な無作為抽出が可能です。オプションで、この関数に使用する文字セットを指定することもできます(デフォルトは英数字)。

*使用例:*

```puppet
fqdn_rand_string(LENGTH, [CHARSET], [SEED])
```

*例:*

```puppet
fqdn_rand_string(10)
fqdn_rand_string(10, 'ABCDEF!@#$%^')
fqdn_rand_string(10, '', 'custom seed')
```

引数:

* 整数、得られる文字列の長さを指定。
* オプションで、文字セットを指定する文字列。
* オプションで、反復的な無作為抽出を可能にするシードを指定する文字列。

*タイプ*: 右辺値

#### `fqdn_rotate`

配列と文字列をランダムな回数で回転させます。`$fqdn` factとオプションのシードを組み合わせると、反復的な無作為抽出が可能です。

*使用例:*

```puppet
fqdn_rotate(VALUE, [SEED])
```

*例:*

```puppet
fqdn_rotate(['a', 'b', 'c', 'd'])
fqdn_rotate('abcd')
fqdn_rotate([1, 2, 3], 'custom seed')
```

*タイプ*: 右辺値

#### `fqdn_uuid`

DNSネームスペースのFQDN文字列をもとに、[RFC 4122](https://tools.ietf.org/html/rfc4122)有効バージョン5 UUIDを返します:

  * fqdn_uuid('puppetlabs.com')は'9c70320f-6815-5fc5-ab0f-debe68bf764c'を返します。
  * fqdn_uuid('google.com')は'64ee70a4-8cc1-5d25-abf2-dea6c79a09c8'を返します。

*タイプ*: 右辺値

#### `get_module_path`

現在の環境について、指定されたモジュールの絶対パスを返します。

```puppet
$module_path = get_module_path('stdlib')
```

Puppet 5.4.0以降では、内蔵の [`module_directory`](https://puppet.com/docs/puppet/latest/function.html#module_directory)関数は同じことを行い、複数の値または配列が与えられている場合、最初に見つかったモジュールへのパスを返します。

*タイプ*: 右辺値

#### `getparam`
リソースのパラメータの値を返します。

引数: リソースリファレンスおよびパラメータの名前。

> 注意: ユーザ定義のリソースタイプは遅れて評価されます。

*例:*

```puppet
# define a resource type with a parameter
define example_resource($param) {
}

# declare an instance of that type
example_resource { "example_resource_instance":
    param => "'the value we are getting in this example''"
}

# Because of order of evaluation, a second definition is needed
# that will be evaluated after the first resource has been declared
#
define example_get_param {
  # This will notice the value of the parameter
  notice(getparam(Example_resource["example_resource_instance"], "param"))
}

# Declare an instance of the second resource type - this will call notice
example_get_param { 'show_notify': }
```

'この例で取得している値'を通知します

Puppet 4.0.0以降では、データタイプ
と[ ]演算子を使用してパラメータ値を取得できます。次の例は、getparam()の呼び出しと同じです。

```puppet
Example_resource['example_resource_instance']['param']
```

#### `getvar`
**非推奨:** この関数は、Puppet 6.0.0で、内蔵の[`getvar`](https://puppet.com/docs/puppet/latest/function.html#getvar)
関数に置き換えられました。新しいバージョンでも、構造化された値への掘り下げがサポートされます。

リモートネームスペースの変数を調べます。

例:　

```puppet
$foo = getvar('site::data::foo')
# $foo = $site::data::fooと同等
```

この関数は、ネームスペースそのものが文字列に保存されている場合に役立ちます:

```puppet
$datalocation = 'site::data'
$bar = getvar("${datalocation}::bar")
# Equivalent to $bar = $site::data::bar
```

*タイプ*: 右辺値

#### `glob`

パスパターンに一致するパスの文字列配列を返します。

引数: パスパターンを指定する文字列または文字列配列。

```puppet
$confs = glob(['/etc/**/*.conf', '/opt/**/*.conf'])
```

*タイプ*: 右辺値

#### `grep`

配列内を検索し、提示された正規表現に一致する要素を返します。

たとえば、`grep(['aaa','bbb','ccc','aaaddd'], 'aaa')`は['aaa','aaaddd']を返します。

Puppet 4.0.0以降では、内蔵の[`filter`](https://puppet.com/docs/puppet/latest/function.html#filter)関数は同じことを行います。正規表現とは対照的に、どのロジックでもフィルタリングに使用できます。

    ['aaa', 'bbb', 'ccc', 'aaaddd']. filter |$x| { $x =~ 'aaa' }

*タイプ*: 右辺値

#### `has_interface_with`

種類および値に基づきブーリアンを返します:

  * macaddress
  * netmask
  * ipaddress
  * network

*例:*

```puppet
has_interface_with("macaddress", "x:x:x:x:x:x")
has_interface_with("ipaddress", "127.0.0.1")    => true
```

種類が提示されていない場合は、インターフェースの有無が確認されます:

```puppet
has_interface_with("lo")                        => true
```

*タイプ*: 右辺値

#### `has_ip_address`

一部のインターフェース上で、リクエストされたIPアドレスがクライアントに存在する場合は`true`を返します。この関数は`interfaces` factで反復され、`ipaddress_IFACE` factsをチェックし、簡単な文字列比較を実行します。

引数: IPアドレスを指定する文字列。

*タイプ*: 右辺値

#### `has_ip_network`

リクエストされたネットワーク内でIPアドレスがクライアントに存在する場合は`true`を返します。この関数は`interfaces` factで反復され、 `network_IFACE` factsをチェックし、簡単な文字列比較を実行します。

引数: IPアドレスを指定する文字列。

*タイプ*: 右辺値

#### `has_key`
**非推奨:** この関数は、内蔵の`in`演算子に置き換えられました。

ハッシュに特定のキー値があるかどうかを判定します。

*例*:

```
$my_hash = {'key_one' => 'value_one'}
if has_key($my_hash, 'key_two') {
  notice('we will not reach here')
}
if has_key($my_hash, 'key_one') {
  notice('this will be printed')
}
```

Puppet 4.0.0以降では、これは、Puppet言語において、次の同等の式を用いて実現できます。

    $my_hash = {'key_one' => 'value_one'}
    if 'key_one' in $my_hash {
      notice('this will be printed')
    }

*タイプ*: 右辺値

#### `hash`

**非推奨:** この関数は、ほとんどすべてのデータタイプの新しい値を作成する内蔵の機能に置き換えられました。
Puppetに内蔵の[`Hash.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-hash-and-struct)関数を参照してください。

配列をハッシュに変換します。

例えば(非推奨)、`hash(['a',1,'b',2,'c',3])`は、 {'a'=>1,'b'=>2,'c'=>3}を返します。

例えば(内蔵)、`Hash(['a',1,'b',2,'c',3])`は、{'a'=>1,'b'=>2,'c'=>3}を返します。

*タイプ*: 右辺値

#### `intersection`

2つの共通部分の配列を返します。

たとえば、`intersection(["a","b","c"],["b","c","d"])`は["b","c"]を返します。

*タイプ*: 右辺値

#### `is_a`

ブーリアンチェックにより、変数が任意のデータタイプのものかどうかを判定します。これは`=~`タイプチェックに相当します。この関数はPuppet 4と、"future"パーサーを備えたPuppet 3でのみ使用できます。

```
foo = 3
$bar = [1,2,3]
$baz = 'A string!'

if $foo.is_a(Integer) {
  notify  { 'foo!': }
}
if $bar.is_a(Array) {
  notify { 'bar!': }
}
if $baz.is_a(String) {
  notify { 'baz!': }
}
```

* タイプに関する詳細は、[Puppetタイプシステム](https://puppet.com/docs/puppet/latest/lang_data.html)を参照してください。
* 値のタイプを特定する各種の方法については、[`assert_type()`](https://puppet.com/docs/puppet/latest/function.html#asserttype)関数を参照してください。

#### `is_absolute_path`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

与えられたパスが絶対パスである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_array`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された変数が配列である場合に`true`を返します。

*タイプ*: 右辺値

#### `is_bool`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された変数がブーリアンである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_domain_name`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された文字列が構文的に正しいドメイン名である場合に`true`を返します。

*タイプ*: 右辺値

#### `is_email_address`

この関数に渡された文字列が有効なメールアドレスである場合にtrueを返します。

*タイプ*: 右辺値


#### `is_float`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された変数がフロート型である場合に`true`を返します。

*タイプ*: 右辺値

#### `is_function_available`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

文字列を引数として受け入れ、Puppetランタイムがその名前を用いて関数にアクセスできるかどうかを判定します。関数が存在する場合は`true`、存在しない場合は`false`を返します。

*タイプ*: 右辺値

#### `is_hash`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された変数がハッシュである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_integer`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この文字列に返された変数が整数である場合に`true`を返します。

*タイプ*: 右辺値

#### `is_ip_address`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された文字列が有効なIPアドレスである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_ipv6_address`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された文字列が有効なIPv6アドレスである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_ipv4_address`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された文字列が有効なIPv4アドレスである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_mac_address`

この関数に渡された文字列が有効なMACアドレスである場合に`true`を返します。

*タイプ*: 右辺値

#### `is_numeric`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された変数が数字である場合に`true`を返します。

*タイプ*: 右辺値

#### `is_string`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

この関数に渡された変数が文字列である場合に`true`を返します。

*タイプ*: 右辺値

#### `join`

**非推奨:** この関数は、Puppet 5.5.0で、内蔵の[`join`](https://puppet.com/docs/puppet/latest/function.html#join)関数に置き換えられました。

区切り文字を用いて、配列を文字列に結合します。たとえば、`join(['a','b','c'], ",")`は"a,b,c"になります。

*タイプ*: 右辺値

#### `join_keys_to_values`

区切り文字を用いて、ハッシュの各キーをそのキーに対応する値と結合し、結果を文字列として返します。

値が配列の場合は、キーは各要素の前に置かれます。返される値は、平坦化した配列になります。

たとえば、`join_keys_to_values({'a'=>1,'b'=>[2,3]}, " is ")`は["a is 1","b is 2","b is 3"]になります。

Puppet 5.0.0以降では、書式の制御が強化されています（インデントや改行、配列とハッシュエントリ、ハッシュエントリのキー/値の間の区切り、配列における値の個々の
書式など)。内蔵の[`String.new`](https://docs.puppet.com/puppet/latest/function.html#conversion-to-string)関数、および`配列`と`ハッシュ`の書式設定オプションを参照してください。

*タイプ*: 右辺値

#### `keys`

**非推奨:** この関数は、Puppet 5.5.0で、内蔵の[`keys`](https://puppet.com/docs/puppet/latest/function.html#keys)関数に置き換えられました。

ハッシュのキーを配列として返します。

*タイプ*: 右辺値

#### `length`

**非推奨:** この関数は、Puppet 5.5.0で、内蔵の[`length`](https://puppet.com/docs/puppet/latest/function.html#length)関数に置き換えられました。

与えられた文字列、配列、ハッシュの長さを返します。廃止された`size()`関数に代わるものです。

*タイプ*: 右辺値

#### `loadyaml`

配列、文字列、ハッシュを含むYAMLファイルをロードし、対応するネイティブデータタイプでデータを返します。

例:　

```puppet
$myhash = loadyaml('/etc/puppet/data/myhash.yaml')
```

第2のパラメータは、ファイルが見つからなかった場合、または構文解析できなかった場合に返されます。

例:　

```puppet
$myhash = loadyaml('no-file.yaml', {'default'=>'value'})
```

*タイプ*: 右辺値

#### `loadjson`

配列、文字列、ハッシュを含むJSONファイルをロードし、対応するネイティブデータタイプでデータを返します。

例:　

最初のパラメータは、絶対ファイルパスまたはURLです。

```puppet
$myhash = loadjson('/etc/puppet/data/myhash.json')
```

第2のパラメータは、ファイルが見つからなかった場合、または構文解析できなかった場合に返されます。

例:　

```puppet
  $myhash = loadjson('no-file.json', {'default'=>'value'})
  ```

*タイプ*: 右辺値

#### `load_module_metadata`

ターゲットモジュールのmetadata.jsonをロードします。モジュールのバージョンや、モジュールの動的サポートに関するオーサーシップの判定に使用できます。

```puppet
$metadata = load_module_metadata('archive')
notify { $metadata['author']: }
```

モジュールのメタデータファイルが存在しない場合、カタログコンパイルに失敗します。これを避ける方法は、以下のとおりです:

```
$metadata = load_module_metadata('mysql', true)
if empty($metadata) {
  notify { "このモジュールにはmetadata.jsonファイルがありません。": }
}
```

*タイプ*: 右辺値

#### `lstrip`

**非推奨:** この関数は、Puppet 6.0.0で、内蔵の[`lstrip`](https://puppet.com/docs/puppet/latest/function.html#lstrip) 関数に置き換えられました。

文字列の左側のスペースを取り除きます。

*タイプ*: 右辺値

#### `max`

**非推奨:** この関数は、Puppet 6.0.0で、内蔵の[`max`](https://puppet.com/docs/puppet/latest/function.html#max) 関数に置き換えられました。

すべての引数の最大値を返します。少なくとも1つの引数が必要です。

引数: 数字または数字を表す文字列。

*タイプ*: 右辺値

#### `member`

変数が配列の構成要素かどうかを判定します。変数には文字列、配列、fixnumが使用できます。

たとえば、`member(['a','b'], 'b')`および`member(['a','b','c'], ['b','c'])`は`true`を返し、`member(['a','b'], 'c')`および`member(['a','b','c'], ['c','d'])`は`false`を返します。

*注*: この関数は、ネスト化した配列には対応していません。最初の引数にネスト化した配列が含まれている場合は、再帰的処理は行われません。

Puppet 4.0.0以降では、Puppet言語において同じことを実行できます。値が単一の場合には、
`in`演算子を使用します。

    'a' in ['a', 'b']  # true

また、配列の場合には、`-`演算子を使用してdiffを計算します。

    ['d', 'b'] - ['a', 'b', 'c'] == []  # 'd'が減算されないため、false
    ['a', 'b'] - ['a', 'b', 'c'] == []  # 'a'と'b'の両方が減算されるため、true

また、Puppet 5.2.0以降では、配列やハッシュの内容をテストする一般的な形式は、内蔵されている[`any`](https://puppet.com/docs/puppet/latest/function.html#any)および[`all`](https://puppet.com/docs/puppet/latest/function.html#all)の各関数を使用することです。

*タイプ*: 右辺値

#### `merge`

2つ以上のハッシュを統合し、その結果得られたハッシュを返します。

*例*:

```puppet
$hash1 = {'one' => 1, 'two' => 2}
$hash2 = {'two' => 'dos', 'three' => 'tres'}
$merged_hash = merge($hash1, $hash2)
# The resulting hash is equivalent to:
# $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}
```

重複キーが存在する場合は、最右のハッシュのキーが上位になります。

Puppet 4.0.0以降では、+ 演算子を使用して同じマージを実行することができます。

    $merged_hash = $hash1 + $hash2

*タイプ*: 右辺値

#### `min`

**非推奨:** この関数は、Puppet 6.0.0で、内蔵の[`min`](https://puppet.com/docs/puppet/latest/function.html#min)関数に置き換えられました。

すべての引数の最小値を返します。少なくとも1つの引数が必要です。

引数: 数字または数字を表す文字列。

*タイプ*: 右辺値

#### `num2bool`

数字または数字の文字列表現を正当なブーリアンに変換します。0または非数字は`false`になります。0より大きい数字は`true`になります。

Puppet 5.0.0以降では、タイプシステムを使用して同じことが行えます。
利用可能な多くのタイプ変換については、Puppetの[`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean) 
関数を参照してください。

    Boolean(0) # false
    Boolean(1) # true

*タイプ*: 右辺値

#### `parsejson`

JSONの文字列を正確なPuppet構造に変換します(ハッシュ、配列、文字列、整数、またはそれらの組み合わせとして)。

引数:
* 第1の引数として、変換されるJSON文字列。
* オプションで、第2のエラーとして、変換に失敗した場合に返される結果。

*タイプ*: 右辺値

#### `parseyaml`

YAMLの文字列を正確なPuppet構造に変換します。

引数:
* 第1の引数として、変換されるYAML文字列。
* オプションで、第2のエラーとして、変換に失敗した場合に返される結果。

*タイプ*: 右辺値

#### `pick`

値のリストから、未定義または空文字列ではない最初の値を返します。引数から任意の数字をとり、すべての値が未定義または空の場合はエラーが生じます。

```puppet
$real_jenkins_version = pick($::jenkins_version, '1.449')
```

*タイプ*: 右辺値

#### `pick_default`

値のリストにある最初の値を返します。`pick()`関数とは異なり、`pick_default()`は、すべての引数が空の場合も失敗にはなりません。そのため、デフォルトとして空の値を使用できます。

*タイプ*: 右辺値

#### `prefix`

配列のすべての要素、またはハッシュのキーに接頭辞を適用します。

例:　

* `prefix(['a','b','c'], 'p')`は['pa','pb','pc']を返します。
* `prefix({'a'=>'b','b'=>'c','c'=>'d'}, 'p')`は{'pa'=>'b','pb'=>'c','pc'=>'d'}を返します。

Puppet 4.0.0以降では、内蔵の[`map`](https://docs.puppet.com/puppet/latest/function.html#map)関数を使用して配列の値を変更します。
この例は、上記の最初の例と同じです。

        ['a', 'b', 'c'].map |$x| { "p${x}" }

*タイプ*: 右辺値

#### `pry`

現在のスコープオブジェクトでpryデバッグセッションを起動します。コンパイル中の特定ポイントにおけるマニフェストコードのデバッグに役立ちます。`puppet apply`の実行中またはフォアグラウンドでPuppet masterを実行しているときにのみ使用する必要があります。PuppetのRubyGemsに`pry` gemがインストールされている必要があります。

*例:*

```puppet
pry()
```

pryセッションで役立つコマンドは以下のとおりです:

* `catalog`を実行すると、現在カタログをコンパイルしているコンテンツを見られます。
* `cd catalog`および`ls`を実行すると、カタログメソッドおよびインスタンス変数を見られます。
* `@resource_table`を実行すると、現在のカタログリソーステーブルを見られます。

#### `pw_hash`

crypt関数を用いてパスワードをハッシュします。ほとんどのPOSIXシステムで使えるハッシュを提供します。

この関数の最初の引数は、ハッシュするパスワードです。`undef`または空文字列の場合は、この関数により`undef`が返されます。

この関数の第2の引数は、使用するハッシュのタイプです。適切なcrypt(3)ハッシュ指定子に変換されます。有効なハッシュタイプは以下のとおりです:

|ハッシュタイプ            |指定子|
|---------------------|---------|
|MD5                  |1        |
|SHA-256              |5        |
|SHA-512 (推奨)|6        |

この関数の第3の引数は、使用するソルトです。

この関数は、Puppet masterのcrypt(3)実装を使用しています。お使いの環境に複数の異なるオペレーティングシステムが含まれている場合は、この関数を使用する前に、互換性があることを確認してください。

*タイプ*: 右辺値

*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `range`

'(start, stop)'の形式で与えられた場合に、領域を配列として外挿します。たとえば、`range("0", "9")`は[0,1,2,3,4,5,6,7,8,9]を返します。ゼロパディングされた文字列は、自動的に整数に変換されます。したがって、`range("00", "09")`は[0,1,2,3,4,5,6,7,8,9]を返します。

非整数文字列を使用できます:

* `range("a", "c")`は、["a","b","c"]を返します。
* `range("host01", "host10")`は、["host01", "host02", ..., "host09", "host10"]を返します。

末尾のゼロを明示的に含める必要があります。そうでないと、下層のRuby関数が適切に機能しません。

第3の引数を渡すと、生成された領域がその間隔で刻まれます。例:

* `range("0", "9", "2")`は["0","2","4","6","8"]を返します。

> 注意: Puppet言語では、タイプシステムを使用して、`整数`と`フロート`の範囲をサポートしています。これらは、指定された回数の反復に適しています。

値のスキップについては、Puppetに内蔵の[`step`](https://docs.puppet.com/puppet/latest/function.html#step)関数を参照してください。

   整数[0, 9]。それぞれの|$x| { notice($x) } #は、0, 1, 2, ... 9を通知します。

*タイプ*: 右辺値

#### `regexpescape`

文字列または文字列の配列を正規表現エスケープします。インプットとして、単一の文字列または配列のいずれかが必要です。

*タイプ*: 右辺値

#### `reject`

配列を検索し、提示された正規表現に一致する要素をすべてリジェクトします。

たとえば、`reject(['aaa','bbb','ccc','aaaddd'], 'aaa')`は['bbb','ccc']を返します。

Puppet 4.0.0以降では、Puppetに内蔵の[`filter`](https://docs.puppet.com/puppet/latest/function.html#filter)関数にも同じことが当てはまります。
stdlibの`reject`関数に相当します。

    ['aaa','bbb','ccc','aaaddd'].filter |$x| { $x !~ /aaa/ }

*タイプ*: 右辺値

#### `reverse`

文字列または配列の順序を逆転します。

> *注意*: Puppetでは、内蔵の[`reverse_each`](https://docs.puppet.com/puppet/latest/function.html#reverse_each)関数を使って同じことが行えます。


#### `round`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`round`](https://puppet.com/docs/puppet/latest/function.html#round)関数に置き換えられました。

数値を最も近い整数に丸めます。

*タイプ*: 右辺値

#### `rstrip`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`rstrip`](https://puppet.com/docs/puppet/latest/function.html#`rstrip`)関数に置き換えられました。

文字列の右側のスペースを取り除きます。

*タイプ*: 右辺値

#### `seeded_rand`

整数の最大値と文字列のシード値を取り、最大値よりも小さい反復可能かつランダムな整数を返します。`fqdn_rand`と同様ですが、シードにノード固有のデータが追加されません。

*タイプ*: 右辺値

#### `seeded_rand_string`

(シード値に基づいて)一貫性のあるランダムな文字列を生成します。異なるホストに一致するパスワードを生成する場合に便利です。

#### `shell_escape`

文字列をエスケープし、Bourneシェルコマンドラインで安全に使用できるようにします。得られる文字列はクォートなしで使用する必要があり、ダブルクォートまたはシングルクォートでの使用は意図されていません。この関数は、Rubyの`Shellwords.shellescape()`関数と同様に挙動します。[Rubyドキュメント](http://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shellescape)を参照してください。

例:　

```puppet
shell_escape('foo b"ar') => 'foo\ b\"ar'
```

*タイプ*: 右辺値

#### `shell_join`

与えられた文字列の配列からコマンドライン文字列を構築します。各配列アイテムが、Bourneシェルで使用できるようにエスケープされます。その後、すべてのアイテムがまとめられ、間にシングルスペースが配されます。この関数は、Rubyの`Shellwords.shelljoin()`関数と同様に挙動します。[Rubyドキュメント](http://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shelljoin)を参照してください。

例:　

```puppet
shell_join(['foo bar', 'ba"z']) => 'foo\ bar ba\"z'
```

*タイプ*: 右辺値

#### `shell_split`

文字列をトークンの配列に分割します。この関数は、Rubyの`Shellwords.shellsplit()`関数と同様に挙動します。[Rubyドキュメント](http://ruby-doc.org/stdlib-2.3.0/libdoc/shellwords/rdoc/Shellwords.html#method-c-shellsplit)を参照してください。

*例:*

```puppet
shell_split('foo\ bar ba\"z') => ['foo bar', 'ba"z']
```

*タイプ*: 右辺値

#### `shuffle`

文字列または配列の順序をランダム化します。

*タイプ*: 右辺値

#### `size`

**非推奨:** この関数は、Puppet 6.0.0で、内蔵の[`size`](https://puppet.com/docs/puppet/latest/function.html#size) 関数に置き換えられました(`サイズ`は、`長さ`のエイリアスです)。

文字列、配列、ハッシュの要素数を返します。この関数は、今後のリリースでは廃止されます。Puppet 4では、`length`関数を使用してください。

*タイプ*: 右辺値

#### `sprintf_hash`

**非推奨:** Puppet 4.10.10および5.3.4では、内蔵の[`sprintf`](https://docs.puppet.com/puppet/latest/function.html#sprintf)関数を使って同じ機能を達成できます。この関数は、今後のリリースでは削除されます。

名前が指定されたテキストのリファレンスでprintfスタイルのフォーマットを実行します。

最初のパラメータは、ハッシュ内での残りのパラメータのフォーマット方法を記述するフォーマット文字列です。詳細については、Rubyの[`Kernel::sprintf`](https://ruby-doc.org/core-2.4.2/Kernel.html#method-i-sprintf)機能のマニュアルを参照してください。

例:　

```puppet
$output = sprintf_hash('String: %<foo>s / number converted to binary: %<number>b',
                       { 'foo' => 'a string', 'number' => 5 })
# $output = 'String: a string / number converted to binary: 101'
```

*Type*: rvalue

#### `sort`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`sort`](https://puppet.com/docs/puppet/latest/function.html#sort)関数に置き換えられました。

文字列と配列を語彙的に分類します。

*タイプ*: 右辺値

>*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `squeeze`

文字列内の連続した繰り返し('aaaa'など)を単一文字に置き換え、新たな文字列を返します。

*タイプ*: 右辺値

#### `str2bool`

特定の文字列をブーリアンに変換します。値'1'、'true'、't'、'y'、'yes'を含む文字列は`true`に変換されます。値'0'、'false'、'f'、'n'、'no'を含む文字列、および空文字列または未定義文字列は`false`に変換されます。その他の値の場合、エラーが生じます。このチェックでは、大文字と小文字は区別されません。

Puppet 5.0.0以降では、タイプシステムを使用して同じことが行えます。
利用可能な多くのタイプ変換については、Puppetの[`Boolean.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-boolean) 
関数を参照してください。

    Boolean('false'), Boolean('n'), Boolean('no') # すべてfalse
    Boolean('true'), Boolean('y'), Boolean('yes') # すべてtrue

*タイプ*: 右辺値

#### `str2saltedsha512`

OS Xバージョン10.7以上で使用されるソルト付きSHA512パスワードハッシュに文字列を変換します。hexバージョンのソルト付きSHA512パスワードハッシュを返します。これは、有効なパスワード属性としてPuppetマニフェストに挿入することができます。

*タイプ*: 右辺値

>*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `strftime`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`strftime`](https://puppet.com/docs/puppet/latest/function.html#`strftime`)関数に置き換えられました。

フォーマットされた時刻を返します。

たとえば、`strftime("%s")`はUnixエポックからの経過時間を返し、`strftime("%Y-%m-%d")`は日付を返します。

引数: `strftime`フォーマットで時間を指定する文字列。詳細については、Ruby [strftime](https://ruby-doc.org/core-2.1.9/Time.html#method-i-strftime)ドキュメントを参照してください。

*タイプ*: 右辺値

>*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

*フォーマット:*

*  `%a`: 曜日の名称の短縮形('Sun')
* `%A`: 曜日の完全な名称('Sunday')
* `%b`: 月の名称の短縮形('Jan')
* `%B`: 月の完全な名称('January')
* `%c`: 推奨される地域の日付および時刻の表現
* `%C`: 世紀(2009年であれば20)
* `%d`: その月の日(01..31)
* `%D`: 日付(%m/%d/%y)
* `%e`: その月の日、1桁の場合は半角空白で埋める( 1..31)
* `%F`: %Y-%m-%d(ISO 8601の日付フォーマット)と同等
* `%h`: %bと同等
* `%H`: 24時間制の時(00..23)
* `%I`: 12時間制の時(01..12)
* `%j`: 年中の通算日(001..366)
* `%k`: 24時間制の時、1桁の場合は半角空白で埋める( 0..23)
* `%l`: 12時間制の時、1桁の場合は半角空白で埋める( 0..12)
* `%L`: ミリ秒(000..999)
* `%m`: その年の月(01..12)
* `%M`: 分(00..59)
* `%n`: 改行(\n)
* `%N`: 秒の小数点以下の桁、デフォルトは9桁(ナノ秒)
  * `%3N`: ミリ秒(3桁)
  * `%6N`: マイクロ秒(6桁)
  * `%9N`: ナノ秒(9桁)
* `%p`: 午前または午後('AM'または'PM')
* `%P`: 午前または午後('am'または'pm')
* `%r`: 12時間制の時刻(%I:%M:%S %pと同等)
* `%R`: 24時間制の時刻(%H:%M)
* `%s`: Unixエポック、1970-01-01 00:00:00 UTCからの経過秒
* `%S`: 秒(00..60)
* `%t`: タブ文字(	)
* `%T`: 24時間制の時刻(%H:%M:%S)
* `%u`: 月曜日を1とした、曜日の数値表現(1..7)
* `%U`: 最初の日曜日を第1週の始まりとした、現在の週を表す数(00..53)
* `%v`: VMS形式の日付(%e-%b-%Y)
* `%V`: ISO 8601形式の暦週(01..53)
* `%W`: 最初の月曜日を第1週の始まりとした、現在の週を表す数(00..53)
* `%w`: 曜日(日曜が0、0..6)
* `%x`: 推奨される日付のみの表現、時刻はなし
* `%X`: 推奨される時刻のみの表現、日付はなし
* `%y`: 世紀なしの年(00..99)
* `%Y`: 世紀ありの年
* `%z`: タイムゾーン、UTCからのオフセット(+0900など)
* `%Z`: タイムゾーンの名称
* `%%`: '%'文字

#### `strip`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`strip`](https://puppet.com/docs/puppet/latest/function.html#`strip`)関数に置き換えられました。

1つの文字列、または配列内のすべての文字列から、冒頭および末尾の空白を削除します。たとえば、`strip("    aaa   ")`は"aaa"になります。

*タイプ*: 右辺値

#### `suffix`

配列のすべての要素、またはハッシュのすべてのキーに接尾辞を適用します。

例:　

* `suffix(['a','b','c'], 'p')`は['ap','bp','cp']を返します。
* `suffix({'a'=>'b','b'=>'c','c'=>'d'}, 'p')`は{'ap'=>'b','bp'=>'c','cp'=>'d'}を返します。

Puppet 4.0.0以降では、内蔵の[`map`](https://docs.puppet.com/puppet/latest/function.html#map)関数を使用して配列の値を変更します。この例は、上記の最初の例と同じです。

    ['a', 'b', 'c'].map |$x| { "${x}p" }

*タイプ*: 右辺値

#### `swapcase`

文字列の現在の大文字と小文字を入れ替えます。たとえば、`swapcase("aBcD")`は"AbCd"になります。

*タイプ*: 右辺値

>*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `time`

現在のUnixエポック時刻を整数として返します。

たとえば、`time()`は'1311972653'などを返します。

Puppet 4.8.0以降、Puppet言語には、``Timestamp` (時点)と`Timespan` (期間)の各データタイプがあります。次の例は、引数なしで`time()`を呼び出すのと同じです。

タイムスタンプ()

*タイプ*: 右辺値

#### `to_bytes`

引数をバイトに変換します。

たとえば、"4 kB"は"4096"になります。

引数: 単一の文字列。

*タイプ*: 右辺値

#### `to_json`

入力値をJSON形式の文字列に変換します。

例えば、`{ "key" => "value" }`は`{"key":"value"}`になります。

*タイプ*: 右辺値

#### `to_json_pretty`

入力値を整形されたJSON形式の文字列に変換します。

例えば、`{ "key" => "value" }`は`{\n  \"key\": \"value\"\n}`になります。

*タイプ*: 右辺値

#### `to_yaml`

入力値をYAML形式の文字列に変換します。

例えば、`{ "key" => "value" }`は`"---\nkey: value\n"`になります。

*タイプ*: 右辺値

#### `try_get_value`

**非推奨:** `dig()`に置き換えられました。

ハッシュおよび配列の複数レイヤー内の値を取得します。

引数:

* 第1の引数として、パスを含む文字列。この引数は、ゼロではじまり、パス区切り文字(デフォルトは"/")で区切ったハッシュキーまたは配列インデックスの文字列として提示してください。この関数は各パスコンポーネントにより構造内を移動し、パスの最後で値を返すよう試みます。

* デフォルトの第2の引数。パスが正しくない場合や、値が見つからない場合、その他のエラーが生じた場合は、この引数が返されます。
* 最後の引数として、パス区切り文字。

```ruby
$data = {
  'a' => {
    'b' => [
      'b1',
      'b2',
      'b3',
    ]
  }
}

$value = try_get_value($data, 'a/b/2')
# $value = 'b3'

# with all possible options
$value = try_get_value($data, 'a/b/2', 'not_found', '/')
# $value = 'b3'

# using the default value
$value = try_get_value($data, 'a/b/c/d', 'not_found')
# $value = 'not_found'

# using custom separator
$value = try_get_value($data, 'a|b', [], '|')
# $value = ['b1','b2','b3']
```

1. **$data** 取り扱うデータ構造。
2. **'a/b/2'** パス文字列。
3. **'not_found'** デフォルト値。何も見つからない場合に返されます。
   (オプション、デフォルトは`undef`)
4. **'/'** パス区切り文字。
   (オプション、デフォルトは*'/'*)

*タイプ*: 右辺値

#### `type3x`

**非推奨:**この関数は、今後のリリースで廃止されます。 

与えられた値のタイプを説明する文字列を返します。タイプとしては、文字列、配列、ハッシュ、フロート、整数、ブーリアンが可能です。Puppet 4では、この代わりに新しいタイプシステムを使用してください。

引数:

* 文字列
* 配列
* ハッシュ
* フロート
* 整数
* ブーリアン

*タイプ*: 右辺値

#### `type_of`

この関数は下位互換性を得るために提供されていますが、Puppetで提供されている内蔵の[type()関数](https://puppet.com/docs/puppet/latest/function.html#type)の使用を推奨します。

与えられた値のリテラル型を返します。Puppet 4が必要です。`if type_of($some_value) <= Array[String] { ... }`のように(これは`if $some_value =~ Array[String] { ... }`に相当します)、`<=`を用いたタイプの比較に役立ちます。

*タイプ*: 右辺値

#### `union`

2つ以上の配列を重複なしで結合したものを返します。

たとえば、`union(["a","b","c"],["b","c","d"])`は["a","b","c","d"]を返します。

*タイプ*: 右辺値

#### `unique`

文字列および配列から重複を削除します。

たとえば、`unique("aabbcc")`は'abc'を、`unique(["a","a","b","b","c","c"])`は["a","b","c"]を返します。

*タイプ*: 右辺値

#### `unix2dos`

与えられた文字列のDOSバージョンを返します。クロスプラットフォームテンプレートでファイルリソースを使用する場合に役立ちます。

*タイプ*: 右辺値

```puppet
file { $config_file:
  ensure  => file,
  content => unix2dos(template('my_module/settings.conf.erb')),
}
```

[dos2unix](#dos2unix)も参照してください。

#### `upcase`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`upcase`](https://puppet.com/docs/puppet/latest/function.html#upcase)関数に置き換えられました。

オブジェクト、配列、オブジェクトのハッシュを大文字に変換します。変換されるオブジェクトは、大文字化に対応するものでなければなりません。

たとえば、`upcase('abcd')`は'ABCD'を返します。

*タイプ*: 右辺値

*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `uriescape`

文字列または文字列の配列をURLエンコードします。

引数: 単一の文字列または文字列の配列。

*タイプ*: 右辺値

>*注:* この関数はRubyクラスの実装にあたり、UTF8との互換性がない可能性があります。互換性を確保するには、Ruby 2.4.0以降でこの関数を使用してください。

#### `validate_absolute_path`

ファイルシステムの絶対パスを表す任意の文字列の有効性を確認します。WindowsおよびUnix形式のパスで機能します。

以下の値が渡されます:

```puppet
$my_path = 'C:/Program Files (x86)/Puppet Labs/Puppet'
validate_absolute_path($my_path)
$my_path2 = '/var/lib/puppet'
validate_absolute_path($my_path2)
$my_path3 = ['C:/Program Files (x86)/Puppet Labs/Puppet','C:/Program Files/Puppet Labs/Puppet']
validate_absolute_path($my_path3)
$my_path4 = ['/var/lib/puppet','/usr/share/puppet']
validate_absolute_path($my_path4)
```

以下の値は失敗になり、コンパイルが中止されます:

```puppet
validate_absolute_path(true)
validate_absolute_path('../var/lib/puppet')
validate_absolute_path('var/lib/puppet')
validate_absolute_path([ 'var/lib/puppet', '/var/foo' ])
validate_absolute_path([ '/var/lib/puppet', 'var/foo' ])
$undefined = `undef`
validate_absolute_path($undefined)
```

*タイプ*: ステートメント

#### `validate_array`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

渡されたすべての値が配列データ構造であることを確認します。このチェックで不合格となった値がある場合は、カタログコンパイルが中止されます。

以下の値が渡されます:

```puppet
$my_array = [ 'one', 'two' ]
validate_array($my_array)
```

以下の値は失敗になり、コンパイルが中止されます:

```puppet
validate_array(true)
validate_array('some_string')
$undefined = `undef`
validate_array($undefined)
```

*タイプ*: ステートメント

#### `validate_augeas`

Augeasレンズを用いて文字列を確認します。

引数:

* 第1の引数として、テストする文字列。
* 第2の引数として、使用するAugeasレンズの名前。
* オプションの第3の文字列として、ファイル内で見つかるべき**ではない**パスのリスト。
* オプションの第4の引数として、ユーザに表示するエラーメッセージ。

Augeasがレンズによる文字列の構文解析に失敗した場合は、構文エラーによりコンパイルが中止されます。 

`$file`変数は、Augeasツリーでテストされる一時ファイルのロケーションを示します。

たとえば、$passwdcontentにユーザの`foo`が含まれないようにするには、第3の引数を以下のようにします:

```puppet
validate_augeas($passwdcontent, 'Passwd.lns', ['$file/foo'])
```

エラーメッセージを生成して表示するには、第4の引数を以下のようにします:

```puppet
validate_augeas($sudoerscontent, 'Sudoers.lns', [], 'Failed to validate sudoers content with Augeas')
```

*タイプ*: ステートメント

#### `validate_bool`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

渡されたすべての値が`true`または`false`であることを確認します。このチェックで不合格となった値がある場合は、カタログコンパイルが中止されます。

以下の値が渡されます:

```puppet
$iamtrue = true
validate_bool(true)
validate_bool(true, true, false, $iamtrue)
```

以下の値は失敗になり、コンパイルが中止されます:

```puppet
$some_array = [ true ]
validate_bool("false")
validate_bool("true")
validate_bool($some_array)
```

*タイプ*: ステートメント

#### `validate_cmd`

外部コマンドにより文字列を確認します。

引数:
* 第1の引数として、テストする文字列。
* 第2の引数として、テストコマンドのパス。この引数は、ファイルパスのプレースホルダ―として%をとります(%プレースホルダーが与えられていない場合、デフォルトはコマンド末尾)。パスした文字列を含む一時ファイルに対してコマンドが起動した場合や、ゼロではない値が返された場合は、構文エラーによりコンパイルが中止されます。
* オプションの第3の引数として、ユーザに表示するエラーメッセージ。

```puppet
# Defaults to end of path
validate_cmd($sudoerscontent, '/usr/sbin/visudo -c -f', 'Visudo failed to validate sudoers content')
```

```puppet
# % as file location
validate_cmd($haproxycontent, '/usr/sbin/haproxy -f % -c', 'Haproxy failed to validate config content')
```

*タイプ*: ステートメント

#### `validate_domain_name`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

渡されたすべての値が構文的に正しいドメイン名であることを確認します。このチェックで不合格となった値がある場合は、カタログコンパイルが中止されます。

以下の値が渡されます:

~~~
$my_domain_name = 'server.domain.tld'
validate_domain_name($my_domain_name)
validate_domain_name('domain.tld', 'puppet.com', $my_domain_name)
~~~

以下の値が不合格となり、コンパイルが中止されます: 

~~~
validate_domain_name(1)
validate_domain_name(true)
validate_domain_name('invalid domain')
validate_domain_name('-foo.example.com')
validate_domain_name('www.example.2com')
~~~

*タイプ*: ステートメント

#### `validate_email_address`

渡されたすべての値が有効なメールアドレスであることを確認します。このチェックで不合格となった値がある場合、コンパイルが失敗します。

以下の値が渡されます:

~~~
$my_email = "waldo@gmail.com"
validate_email_address($my_email)
validate_email_address("bob@gmail.com", "alice@gmail.com", $my_email)
~~~

以下の値が不合格となり、コンパイルが中止されます: 

~~~
$some_array = [ 'bad_email@/d/efdf.com' ]
validate_email_address($some_array)
~~~

*タイプ*: ステートメント

#### `validate_hash`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

渡されたすべての値がハッシュデータ構造であることを確認します。このチェックで不合格となった値がある場合は、カタログコンパイルが中止されます。

以下の値が渡されます:

```puppet
$my_hash = { 'one' => 'two' }
validate_hash($my_hash)
```

以下の値は失敗になり、コンパイルが中止されます:

```puppet
validate_hash(true)
validate_hash('some_string')
$undefined = `undef`
validate_hash($undefined)
```

*タイプ*: ステートメント

#### `validate_integer`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

整数または整数の配列を確認します。いずれかがチェックで不合格になった場合には、カタログコンパイルが中止されます。

引数:

* 第1の引数として、整数または整数の配列。
* オプションの第2の引数として、最大値。第1の引数(のすべての要素)は、この最大値以下でなければなりません。
* オプションの第3の引数として、最小値。第1の引数(のすべての要素)は、この最大値以上でなければなりません。

第1の引数が整数または整数の配列でない場合や、第2または第3の引数が整数に変換できない場合は、この関数は失敗になります。ただし、最小値が与えられている場合は(この場合に限られます)、第2の引数を空文字列または`undef`にすることが可能です。これは、最小チェックを確実に行うためのプレースホルダーとして機能します。

以下の値が渡されます:

```puppet
validate_integer(1)
validate_integer(1, 2)
validate_integer(1, 1)
validate_integer(1, 2, 0)
validate_integer(2, 2, 2)
validate_integer(2, '', 0)
validate_integer(2, `undef`, 0)
$foo = `undef`
validate_integer(2, $foo, 0)
validate_integer([1,2,3,4,5], 6)
validate_integer([1,2,3,4,5], 6, 0)
```

* 加えて、上述のすべて。ただし、文字列として渡された値を任意に組み合わせたもの('1'または"1")。
* 加えて、上述のすべて。ただし、負の整数値を(適切に)組み合わせたもの。

以下の値は失敗になり、コンパイルが中止されます:

```puppet
validate_integer(true)
validate_integer(false)
validate_integer(7.0)
validate_integer({ 1 => 2 })
$foo = `undef`
validate_integer($foo)
validate_integer($foobaridontexist)

validate_integer(1, 0)
validate_integer(1, true)
validate_integer(1, '')
validate_integer(1, `undef`)
validate_integer(1, , 0)
validate_integer(1, 2, 3)
validate_integer(1, 3, 2)
validate_integer(1, 3, true)
```

* 加えて、上述のすべて。ただし、文字列として渡された値を任意に組み合わせたもの (`false`、または"false")。
* 加えて、上述のすべて。ただし、負の整数値を不適切に組み合わせたもの。
* 加えて、上述のすべて。ただし、配列内の非整数アイテムまたは最大/最小引数を用いたもの。

*タイプ*: ステートメント

#### `validate_ip_address`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

IPv4アドレスかIPv6アドレスかにかかわらず、引数がIPアドレスであることを確認します。また、ネットマスクによりIPアドレスを確認します。

引数: IPアドレスを指定する文字列。

以下の値が渡されます:

```puppet
validate_ip_address('0.0.0.0')
validate_ip_address('8.8.8.8')
validate_ip_address('127.0.0.1')
validate_ip_address('194.232.104.150')
validate_ip_address('3ffe:0505:0002::')
validate_ip_address('::1/64')
validate_ip_address('fe80::a00:27ff:fe94:44d6/64')
validate_ip_address('8.8.8.8/32')
```

以下の値は失敗になり、コンパイルが中止されます:

```puppet
validate_ip_address(1)
validate_ip_address(true)
validate_ip_address(0.0.0.256)
validate_ip_address('::1', {})
validate_ip_address('0.0.0.0.0')
validate_ip_address('3.3.3')
validate_ip_address('23.43.9.22/64')
validate_ip_address('260.2.32.43')
```


#### `validate_legacy`

指定したタイプおよび非推奨の確認関数の両方に照らして値を確認します。両方にパスした場合はそのままパスし、片方の確認のみにパスした場合はエラーが生じ、両方の確認でfalseが返された場合は失敗になります。

引数:

* 値のチェックに用いるタイプ。
* 過去の確認関数のフルネーム。
* チェックする値。
* 過去の確認関数に必要な引数の不特定数。

例:

```puppet
validate_legacy('Optional[String]', 'validate_re', 'Value to be validated', ["."])
```

この関数は、Puppet 3形式の引数確認(stdlibの`validate_*`関数を使用)からPuppet 4データタイプへのモジュールのアップデートに対応しており、Puppet 3形式の確認に頼っている場合も機能性が中断することはありません。

> 注: この関数は、Puppet 4.4.0 (PE 2016.1)以降にのみ対応しています。

##### モジュールユーザへ

Puppet 4を使用している場合、`validate_legacy`関数を使えば、非推奨のPuppet 3の`validate_*`関数を探し、分離することができます。これらの関数は、stdlibバージョン4.13時点で非推奨になっており、今後のstdlibバージョンでは削除されます。

Puppet 4では、[データタイプ](https://puppet.com/docs/puppet/latest/lang_data.html)を用いた改良版のユーザ定義タイプのチェックが可能です。データタイプでは、Puppet 3の`validate_*`関数で見られた、不整合につながるいくつかの問題を回避できます。例えば、[validate_numeric](#validate_numeric)では、数字だけでなく、数字の配列や数字のように見える文字列も意図に反して許可されていました。

Puppet 4とともに、非推奨の `validate_*`関数を用いたモジュールを使用している場合は、非推奨メッセージが表示されることがあります。`validate_legacy`関数を使えば、そうした差異を可視化し、より明快なPuppet 4構文に簡単に移行することができます。

表示される非推奨メッセージは、使用しているモジュールやデータによって異なることがあります。以下の非推奨メッセージは、Puppet 4でのみデフォルトで表示されます:

* `Notice: Accepting previously invalid value for target type '<type>'`: このメッセージは、情報提供の目的のみで表示されるものです。使用している値は、新形式で許可されていますが、旧確認関数では無効となります。
* `Warning: This method is deprecated, please use the stdlib validate_legacy function`: モジュールがまだ`validate_legacy`にアップグレードされていません。[deprecation](#deprecation)オプションを使用してさしあたり警告を解除するか、モジュールの開発者に修正版を提出させてください。この問題の解決方法については、以下の[モジュール開発者へ](#モジュール開発者へ)を参照してください。
* `Warning: validate_legacy(<function>) expected <type> value, got <actual type>_`: コードが渡す値は、Puppet 3形式の確認では認められますが、次バージョンのモジュールでは認められません。ほとんどの場合、数字またはブーリアンからクォートを削除すれば、この問題を解決することができます。
* `Error: Evaluation Error: Error while evaluating a Resource Statement, Evaluation Error: Error while evaluating a Function Call, validate_legacy(<function>) expected <type> value, got <actual type>`: コードの渡す値は、新形式の確認でも旧形式の確認でも認められません。

##### モジュール開発者へ

`validate_legacy`関数は、モジュールユーザの使用している機能を中断させずに、 Puppet 3形式の確認からPuppet 4形式の確認に移行するのに役立ちます。

Puppet 4形式の確認に移行すれば、[データタイプ](https://puppet.com/docs/puppet/latest/lang_data.html)を用いた、より明確なユーザ定義タイプのチェックが可能になります。Puppet 3の`validate_*` 関数の多くは、確認という点で驚くほど多くの穴があります。例えば、[validate_numeric](#validate_numeric)では、細部をコントロールできないため、数字だけでなく、数字の配列や数字のように見える文字列も許可されます。

クラスおよび定義タイプの各パラメータについて、使用する新しいPuppet 4データタイプを選択してください。たいていの場合、新しいデータタイプにより、元の`validate_*`関数とは異なる値のセットを使用できるようになります。以下のような状況になります:

|              | `validate_` pass | `validate_` fail |
| ------------ | ---------------- | ---------------- |
| タイプに一致します | 成功             | 成功、通知     |
| タイプの失敗   | 成功、廃止予定 | 失敗             |

現在のところ、確認後のコードでも、すべての可能な値に対処する必要がありますが、新形式にマッチする値のみを渡すように、コードのユーザがマニフェストを変更することができます。

stdlibの`validate_*`関数それぞれについて、マッチする`Stdlib::Compat::*`タイプがあり、適切な値のセットが許可されます。注意事項については、stdlibソースコードの `types/`ディレクトリにあるドキュメントを参照してください。

たとえば、数字のみが許可されるクラスを与えると、以下のようになります:

```puppet
class example($value) {
  validate_numeric($value)
```

得られる確認コードは、以下のようになります:

```puppet
クラスの例(
  Variant[Stdlib::Compat::Numeric, Numeric] $value
) {
  validate_legacy(Numeric, 'validate_numeric', $value)
```

ここでは、`$value`のタイプが`Variant[Stdlib::Compat::Numeric, Numeric]`と定義されています。これにより、任意の`Numeric` (新形式)のほか、`validate_numeric`で(`Stdlib::Compat::Numeric`を通じて)これまで許可されていたすべての値を使用できます。

`validate_legacy`を呼び出すと、適切なログまたは失敗メッセージのトリガーが処理されます。これには、新形式、以前の確認関数の名称、およびその関数のすべての引数が必要です。

お使いのモジュールがまだPuppet 3をサポートしている場合は、これは互換性を破る変更になります。`metadata.json`要件セクションをアップデートしてモジュールがもうPuppet 3をサポートしていないことを示し、モジュールのメジャーバージョンを放棄してください。この変更を加えても、モジュールに関する既存のすべてのテストにパスするはずです。新たに可能になった値について、追加のテストを作成してください。

これは互換性を破る変更であることから、取り除きたいすべてのパラメータについて [`deprecation`](#deprecation)をコールしたり、パラメータにさらなる制約を追加したりする良い機会でもあります。

このバージョンのリリース後、互換性を破る変更を加えた別のリリースを公開し、すべての互換性タイプおよび `validate_legacy`のコールを削除することができます。その時点で、コードを実行し、過去に可能だった値に関する残余要素を取り除くこともできます。

そうした変更については、必ずCHANGELOGおよびREADMEで通告してください。

#### `validate_numeric`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

数値または数値の配列や文字列を確認します。いずれかがチェックに失敗した場合には、カタログコンパイルが中止されます。

引数:

* 数値、または数値の配列か文字列。
* オプションで、最大値。第1の引数(のすべての要素) は、この最大値以下でなければなりません。
* オプションで、最小値。第1の引数(のすべての要素)は、この最小値以上でなければなりません。

第1の引数が数値(整数またはフロート)または数値の配列が文字列でない場合や、第2および第3の引数が数値に変換できない場合は、この関数は失敗になります。最小値が与えられている場合は(この場合に限られます)、第2の引数を空文字列または`undef`にすることが可能です。これは、最小チェックを確実に行うためのプレースホルダーとして機能します。

パスおよび失敗の使用については、[`validate_integer`](#validate-integer)を参照してください。同じ値がパスおよび失敗します。ただし、`validate_numeric`では、浮動小数点値も許可されます。

*タイプ*: ステートメント

#### `validate_re`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

1つまたは複数の正規表現に照らして、文字列の簡単な確認を行います。

引数:

* 第1の引数として、テストする文字列。この引数が文字列でない場合、コンパイルが中止されます。クォートを用いて強制的に文字列化してください。
* 第2の引数として、文字列化した正規表現(区切り文字//なし)または正規表現の配列。
* オプションの第3の引数として、ユーザに表示するエラーメッセージ。

第2の引数の正規表現が第1の引数で渡した文字列にマッチしない場合は、構文エラーによりコンパイルが中止されます。

以下の文字列により、正規表現に照らして確認が行われます:

```puppet
validate_re('one', '^one$')
validate_re('one', [ '^one', '^two' ])
```

以下の文字列では、確認に失敗し、コンパイルが中止されます:

```puppet
validate_re('one', [ '^two', '^three' ])
```

エラーメッセージの設定方法:

```puppet
validate_re($::puppetversion, '^2.7', 'The $puppetversion fact value does not match 2.7')
```

強制的に文字列化するには、クォートを使用してください:

  ```
  validate_re("${::operatingsystemmajrelease}", '^[57]$')
  ```

*タイプ*: ステートメント

#### `validate_slength`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

文字列(または文字列の配列)が指定した長さ以下であることを確認します。

引数:

* 第1の引数として、文字列または文字列の配列。
* 第2の引数として、長さの最大値を示す数値。
* オプションの第3の引数として、長さの最小値を示す数値。

  以下の値が渡されます:

```puppet
validate_slength("discombobulate",17)
validate_slength(["discombobulate","moo"],17)
validate_slength(["discombobulate","moo"],17,3)
```

以下の値は失敗になります:

```puppet
validate_slength("discombobulate",1)
validate_slength(["discombobulate","thermometer"],5)
validate_slength(["discombobulate","moo"],17,10)
```

*タイプ*: ステートメント

#### `validate_string`

**非推奨:**今後のバージョンのstdlibでは削除されます。[`validate_legacy`](#validate_legacy)を参照してください。

渡したすべての値が文字列データ構造であることを確認します。このチェックに失敗した値がある場合は、カタログコンパイルが中止されます。

以下の値が渡されます:

```puppet
$my_string = "one two"
validate_string($my_string, 'three')
```

以下の値は失敗になり、コンパイルが中止されます:

```puppet
validate_string(true)
validate_string([ 'some', 'array' ])
```

注:* validate_string(`undef`)は、このバージョンの関数APIでは失敗しません。

代わりに、以下を使用してください:

  ```
  if $var == `undef` {
    fail('...')
  }
  ```

*タイプ*: ステートメント

#### `validate_x509_rsa_key_pair`

OpenSSLにより、PEMフォーマットされたX.509認証および秘密鍵を確認します。認証の署名が提供された鍵から作成されたものであることを確認します。

このチェックに失敗した値がある場合は、カタログコンパイルが中止されます。

引数:

* 第1の引数として、X.509認証。
* 第2の引数として、RSAプライベートキー。

```puppet
validate_x509_rsa_key_pair($cert, $key)
```

*タイプ*: ステートメント

#### `values`

**非推奨:**この関数は、Puppet 5.5.0で、内蔵の[`values`](https://puppet.com/docs/puppet/latest/function.html#values)関数に置き換えられました。

与えられたハッシュの値を返します。

たとえば、`$hash = {'a'=1, 'b'=2, 'c'=3} values($hash)`を与えると、[1,2,3]を返します。

*タイプ*: 右辺値

#### `values_at`

ロケーションをもとに、配列内の値を探します。

引数:

* 第1の引数として、解析したい配列。
* 第2の引数として、以下の値の任意の組み合わせ:
  * 単一の数値インデックス。
  * 'start-stop'の形式での範囲(4-9など)。
  * 上記を組み合わせた配列。

例:　

* `values_at(['a','b','c'], 2)`は['c']を返します。
* `values_at(['a','b','c'], ["0-1"])`は['a','b']を返します。
* `values_at(['a','b','c','d','e'], [0, "2-3"])`は['a','c','d']を返します。

Puppet 4.0.0以降では、インデックスで配列をスライスし、言語で直接カウントすることができます。
負の値は、配列の"最後から"と解釈されます。例えば、次のようになります。

```puppet
['a', 'b', 'c', 'd'][1, 2]   # results in ['b', 'c']
['a', 'b', 'c', 'd'][2, -1]  # results in ['c', 'd']
['a', 'b', 'c', 'd'][1, -2]  # results in ['b', 'c']
```

*タイプ*: 右辺値

#### `zip`

与えられた第1の配列から1つの要素をとり、与えられた第2の配列の対応する要素と結合します。これにより、n-要素配列のシーケンスが生成されます。*n*は、引数の数より1大きくなります。たとえば、`zip(['1','2','3'],['4','5','6'])`は["1", "4"], ["2", "5"], ["3", "6"]を返します。*タイプ*: 右辺値。

## 制約事項

Puppet Enterprise 3.7では、stdlibモジュールがPEに含まれていません。PEユーザは、Puppetと互換性のあるstdlibの最新リリースをインストールする必要があります。

サポートされているオペレーティングシステムの一覧については、[metadata.json](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/metadata.json)を参照してください。

### バージョン互換性

バージョン | Puppet 2.6 | Puppet 2.7 | Puppet 3.x | Puppet 4.x |
:---------------|:-----:|:---:|:---:|:----:
**stdlib 2.x**  | **yes** | **yes** | いいえ | いいえ
**stdlib 3.x**  | いいえ    | **yes**  | **yes** | いいえ
**stdlib 4.x**  | いいえ    | **yes**  | **yes** | いいえ
**stdlib 4.6+**  | いいえ    | **yes**  | **yes** | **yes**
**stdlib 5.x**  | いいえ    | いいえ  | **yes**  | **yes**

**stdlib 5.x**:  stdlib 5.xのリリース時には、Puppet 2.7.xのサポートが廃止されます。[この説明](https://github.com/puppetlabs/puppetlabs-stdlib/pull/176#issuecomment-30251414)を参照してください。

## 開発

Puppet ForgeのPuppet Labsモジュールはオープンプロジェクトで、良い状態に保つためには、コミュニティの貢献が必要不可欠です。Puppetが役に立つはずでありながら、私たちがアクセスできないプラットフォームやハードウェア、ソフトウェア、デプロイ構成は無数にあります。私たちの目標は、できる限り簡単に変更に貢献し、みなさまの環境で私たちのモジュールが機能できるようにすることにあります。最高の状態を維持できるようにするために、コントリビュータが従う必要のあるいくつかのガイドラインが存在します。詳細については、[モジュールコントリビューションガイド](https://docs.puppetlabs.com/forge/contributing.html)を参照してください。

このモジュールの一部に関するバグの報告または調査は、
[http://tickets.puppetlabs.com/browse/MODULES](http://tickets.puppetlabs.com/browse/MODULES)からお願いします。

## コントリビュータ

コントリビュータのリストは、[https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors](https://github.com/puppetlabs/puppetlabs-stdlib/graphs/contributors)で見ることができます。
