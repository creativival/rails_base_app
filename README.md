# README
 
# Features
 
Rails のベースアプリ
Devise
Bootstrap
Rspec
Administrate
を導入済み
 
# Requirement
 
Ruby 2.7.2

Rails 6.0.3.4

PostgeSQL 12.4
 
# Installation

別のレポジトリで開発を続けるには次の手順を進めてください。

```
$ cd GitHub/

// clone
$ git clone git@github.com:creativival/rails_base_app.git new_app_name
Cloning into 'new_app_name'...
Enter passphrase for key '/Users/nspenchan/.ssh/id_rsa': 
remote: Enumerating objects: 884, done.
remote: Counting objects: 100% (884/884), done.
remote: Compressing objects: 100% (483/483), done.
remote: Total 884 (delta 470), reused 737 (delta 323), pack-reused 0
Receiving objects: 100% (884/884), 8.51 MiB | 741.00 KiB/s, done.
Resolving deltas: 100% (470/470), done.

// remote-url を確認
$ cd new_app_name/
$ git remote -v
origin	git@github.com:creativival/rails_base_app.git (fetch)
origin	git@github.com:creativival/rails_base_app.git (push)

// remote-url を変更
$ git remote set-url origin git@github.com:creativival/new_app_name.git
$ git remote -v
origin	git@github.com:creativival/new_app_name.git (fetch)
origin	git@github.com:creativival/new_app_name.git (push)

// push
$ git push origin main
Enter passphrase for key '/Users/nspenchan/.ssh/id_rsa': 
Enumerating objects: 884, done.
Counting objects: 100% (884/884), done.
Delta compression using up to 8 threads
Compressing objects: 100% (336/336), done.
Writing objects: 100% (884/884), 8.51 MiB | 2.53 MiB/s, done.
Total 884 (delta 470), reused 884 (delta 470)
remote: Resolving deltas: 100% (470/470), done.
To github.com:creativival/new_app_name.git
 * [new branch]      main -> main

```

データベースの作成

```
$ pg_ctl -D /usr/local/var/postgres start
// postgresql データベースを用意する
$ createdb new_app_name_development -O <mac_user_name>
$ createdb new_app_name_test -O <mac_user_name>
$ psql -l

// 参照するデータベースを変更する
config/database.yml
全て置換 rails_base_app -> new_app_name
```
 
Rails 初期設定

```
$ yarn install
$ bundle install
$ bundle exec rails db:migrate
$ bundle exec rails server
```

# Usage
 
DEMOの実行方法など、"hoge"の基本的な使い方を説明する
 
```bash

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