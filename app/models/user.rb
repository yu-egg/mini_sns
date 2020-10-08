class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :sns_credentials

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create #first_or_create保存するレコードがデータベースに存在するか検索を行い、検索した条件のレコードがあればそのレコードのインスタンスを返し、なければ新しくインスタンスを保存するメソッドです。
    # sns認証したことがあればアソシエーションで取得
    # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = User.where(email: auth.info.email).first_or_initialize( #first_or_initializewhereメソッドとともに使うことで、whereで検索した条件のレコードがあればそのレコードのインスタンスを返し、なければ新しくインスタンスを作るメソッドです。
    nickname: auth.info.name,
      email: auth.info.email
    )
    if user.persisted? ## userが登録済みであるか判断を行い、「if文」の中が呼ばれます。新規登録時は、SnsCredentialモデルに保存されるタイミングで、user_idが確定していなかったので、SnsCredentialモデルとUserモデルは紐付いていません。ログインの際に、sns.userを更新して紐付けを行います。
      sns.user = user
      sns.save
    end
    user
  end
end
#first_or_createとfirst_or_initializeの違いは以下になります。
# first_or_create	新規レコードをデータベースに保存する
# first_or_initialize	新規レコードをデータベースに保存しない