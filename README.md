# README
 
# Features
 
Actions on Google と連携するサイトを作成する
 
# Requirement
 
Ruby 2.7.2

Rails 6.0.3.4

PostgeSQL 12.4
 
# Installation

クローン

```
$ cd <rails_apps_directory>
$ git clone https://github.com/creativival/voice_origami.git
$ cd voice_origami
```

データベースの作成

```
$ pg_ctl -D /usr/local/var/postgres start
$ createdb voice_origami_development -O <mac_user_name>
$ createdb voice_origami_test -O <mac_user_name>
```
 
Rails 初期設定

```
$ bundle install
$ bundle exec rails db:migrate RAILS_ENV=development
$ bundle exec rails db:migrate RAILS_ENV=test
```

Yarn

```
$ yarn add
```
# Usage
 
DEMOの実行方法など、"hoge"の基本的な使い方を説明する
 
```bash
git clone https://github.com/hoge/~
cd examples
python demo.py
```
 
# Note
 
注意点などがあれば書く
 
# Author
 
作成情報を列挙する
 
* 作成者
* 所属
* E-mail
 
# License
ライセンスを明示する
 
"hoge" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).
 
社内向けなら社外秘であることを明示してる
 
"hoge" is Confidential.