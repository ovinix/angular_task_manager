user = User.create!( name:  "Example User",
              email: "foo@bar.com",
              password:              "password",
              password_confirmation: "password")

user.lists.create!( title: "RubyGarage assigments" )
user.lists.create!( title: "For Home" )

user.lists.first.tasks.create!( user_id: user.id,
                                   content: "Clean the rooom" )
user.lists.first.tasks.create!( user_id: user.id,
                                   content: "Buy a milk" )
user.lists.first.tasks.create!( user_id: user.id,
                                   content: "Call Mam" )