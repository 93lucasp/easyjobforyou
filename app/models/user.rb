class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  #verifichiamo che il nome sia presente e univoco
  #has_secure_password si occupa del confronto tra password con il form di conferma

  has_secure_password

end
