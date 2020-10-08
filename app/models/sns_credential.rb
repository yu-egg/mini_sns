class SnsCredential < ApplicationRecord
  belongs_to :user, optional: true
end

# アソシエーションにオプションを付けましょう
# 取得したFacebook（またはGoogle）の情報を、外部キーが無くても保存できるオプションを付与します。
# SnsCredentialモデルに記述してあるoptional: true とは、レコードを保存する際に、外部キーの値がない場合でも保存ができるオプションです。
# 新規登録時は、「nickname」「email」の値をビューに表示させることで、新規登録を行っていました。しかし、パスワードを非表示にする場合は、SnsCredentialモデルのレコード情報で条件分岐を行います。よって、「user_id」が生成されていないタイミングでも保存する必要があります。