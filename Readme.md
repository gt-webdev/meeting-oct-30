Introducing Bookface!
=====================

Starting today, `{gt: webdev}` will be working on a brand now social-networking 
site!

This site is called Bookface, and it'll offer great features that help users
connect with their friends and networks.

# Instructions

## Creating a new project

To start off, we'll need to have a new project. Fortunately, rails makes it 
very easy to create a new project, just run `rails new bookface` in your
terminal. This will create a new folder named 'bookface' in the same folder
our terminal was "in" when we ran the command. While we're still in terminal,
let's go into our new folder (`cd bookface`) and do some modifications.

### the Gemfile

In our 'bookface' folder, there's a file named `Gemfile`. This file contain
several statements, most of which begin with `gem` or `group`. Each `gem` 
command represents a gem that our project requires (recall that a 'gem' is
a package or a library of ruby code that we can import into a project and use).

The first change we're going to make is needed by [heroku](http://heroku.com).
By default, Ruby on Rails will use a database system called `sqlite3`, this
SQL implementation makes it very quick and easy to set-up a database for a
small project, but offers very poor performance and terrible scalability.
In fact, heroku offers no support for sqlite, instead encouraging usage of
a SQL system called `PostgreSQL` (pronounced 'Postgres' or 'Postgres SQL').
If you have a Postgres server on your local machine you can replace the line
which says `gem 'sqlite3'` with `gem 'pg'` (the 'pg' is the name of the gem
used for interfacing a Postgres server), but in most cases it makes more sense
to replace the line with a slightly more complex block:

    group :development do
      gem 'sqlite3'
    end

    group :production do
      gem 'pg'
    end

By doing so, we cause our app to use sqlite3 on our local machine, but if we
ever choose to push it to heroku (or other similar services), the app will
switch to Postgres.

Now, before we close our Gemfile, let's import a new gem called `devise`, just
add the following line somewhere in your Gemfile (make sure that it isn't
within a `group` statement:

    gem 'devise'

Now our Gemfile is all set to get started, we just need to install all the gems
and we could get started. The program that manages gem installation is called 
the `bundler` which we can invoke with the command line instruction `bundle`.
To install our gems, just run `bundle install`.

If you look at the output of `bundle install` you'll see a line similar to
`Using devise (2.1.2)`, this is a good indication that your change was
successful.

## User Management and Devise

User management is a relatively advanced topic in web-development. The biggest
issue is usually security. Namely, it's the web-developers responsibility to 
make sure that some information is not accessible to the general public.
Naturally, the most important piece of information we need to keep is the
password the user selected for his account.

Rather, than discuss cryptography and any one of the many approaches we can
use to manage user accounts and passwords, we'll use the gem 'devise' which
we imported earlier. More information on the gem can be found on [its official
page on rubygems.org](http://rubygems.org/gems/devise).

### rails generate

One of the nice things that rails offers is the ability to generate predefined
packages of code using built in "generators". These generators are invoked
using the command line instruction `rails generate`. 

When we installed 'devise' using 'bundler', we also installed a generator
which rails can use to produce sample code which we can use for quickly
implementing user-management and authentication. In this tutorial we'll use
this generator to create a starting point for our models and views for the 
user object.

We begin by running `rails generate devise:install`, This command should output
a message regarding changing some configurations, for now we can ignore this
message. What the previous command did was copy some sample config files into
our project that devise will use in our app. `config/initializers/devise.rb`
cantains many settings and comments which can help customize devise's behavior.

Now that devise is set-up, we can go ahead and generate our user models. In
the past we may have used `rails generate model user` to create support for
user-objects in our apps. Devise adds a similar function through its own
generator, creating a devise-supported user model is done through the simple
command: `rails generate devise user`.

The output of our generator command should point out that a db-migration file
was created. If we open the file we may notice that aside from commands that
create the appropriate fields in the database, there are several commented-out
commands. These commands control settings such as whether new accounts need
to be confirmed via e-mail or whether a user should be "locked" if log-in is
attempted too many times with wrong passwords. 

Usually, when some command we run creates db-migrations file, we'll need to
go through the migration process. This is done by calling the smple command:

    rake db:migrate

`rake` is a small utility that uses a config file (named a Rakefile) to carry
out build-tasks. In this case, we're telling rake to update our db with space
for the new user-model that we created.

### finalizing users

After the previous steps, we should be able to use our user-models. We can
start our server using `rails s` (or `rails server`) and use a browser to open
[http://localhost:3000/users/sign\_up](http://localhost:3000/users/sign_up).
A sign-up form should be brought up. We can use this forrm to create a new
account on bookface.

Now we have users implemented, but there's still more we need to do. If you
examine our sign-up page, you'll see that we don't have a way to input the
user's first and last names. Fortunately, this is a common task in rails and
there's a quick command that can help us get started:

    rails g migration add_names_to_users first_name:string last_name:string

In this command, the `rails g` in just shorthand for `rails generate`; this
is the same as using `rails s` instead of `rails server`. What we did, was
create a new migration file (not too different from the one we created when
we generated our 'devise users'). Running this migration file will create
two new fields for our user-models. These fields are configured by the last
two parameters of our command `first_name:string` and `last_name:string`. As
you may expect, the twe fields we creatad are both strings which we named
'first\_name' and 'last\_name'.

As before, when we create a new migration file, we usually need to follow
it up by running `rake db:migrate`.

Now, we'll need to create and modify the appropriate views to allow the user
to add the first name and last name to their user account. We begin by
generating our views through devise:

    rails g devise:views

Now, before we test this, we'll need to go in and manually add the fields
for first and last names. All we need to do is open 
`app/views/devise/registration/new.html.erb` and make the following additions
right above the similar lines for 'email':

    ## app/views/devise/registration/new.html.erb
    #
    ...
    <div><%= f.label :first_name %><br />
    <%= f.text_field :first_name %></div>

    <div><%= f.label :last_name %><br />
    <%= f.text_field :last_name %></div>
    ...

Now, if we were to test this out, we'll receive a message saying that rails
doesn't allow us to change `first_name` and `last_name`. We can prevent this
by openning `app/models/user.rb` and modifying the `attr_accessible` function
call:

    ## app/models/user.rb
    #
    ...
    attr_accessible :email, :password, :password_confirmation, :remember_me, 
                    :first_name, :last_name
    ...

now if you run the server and open up 
[http://localhost:3000/users/sign\_up](http://localhost:3000/users/sign_up),
you should be able to input your first and last names.

Our only remaining issue is that after signing-in, we're faced with the defailt
"New Rails App" page. Although this could arguable be a decent front-page for
bookface, our purposes are better served by removing this `index.html` file and
creating  our own front page (we can delete the sample page by running
`rm public/index.html`).

For now, we'll create a new Controller for the user-object which we'll also use
to control our front page, we can generate it using (what else?) `rails g`:

    rails g controller users

Notice that we use the plural "users" and not "user", this is the common 
rails convention for controller and issues could arise if you take the liberty
to singularize nouns that rails expect to be plural.

Now, let's just edit our routes file (found in `config/routes.rb`):

    ## config/routes.rb
    #
    ...
    root :to => 'users#index'
    ...

we'll also need to create this `index` function that we're  referring to. for
now even an empty function should suffice. Open 
`app/controllers/users_controller.rb` and add the following method:

    def index
    end

By default, rails will search for a corresponding file named index.html.erb.
Since we never created the file, trying to view this page will return an 
error. Fortunately, the fix is simple, just create a new empty file named
`index.html.erb` in your `app/views/users/` folder (notice that some editors
will not save an empty file to disk, this can be overriden in Vim using `:w!`
instead of the simple `:w`; another solution is to place some random html content
in your new file).

And we'll need to make a small addition to our application layout file. This
file is located at `app/views/layouts/application.html.erb` and contain some
sample html that's displayed as a part of every page in our app.

If you open this layout file, you'll see that it's not really intricate, just
your basic empty html page. The line that reads `<%= yield %>` is a placeholder
for the specific page the user is trying to view. 

Our goal is to add a sign-out, sign-in and a register buttons on every page.
We also need to add some logic to determite when a user is or isn't signed-in.
To do this we make tho following addition into the `<body>` of our document,
any addition before the "yield" statement will appear at the top of our pages
and below the "yield" statement will appear at the bottom:

    <% if current_user %>
      <%= link_to 'sign out', destroy_user_session_path, method: :delete %>
    <% else %>
      <%= link_to 'sign in', new_user_session_path %>
      <%= link_to 'register', new_user_registration_path %>
    <% end %>

This block of code is a bunch basic embedded ruby statement, the top one
checks to see if the `current_user` variable is defined (which devise defines
for us if a user is currently logged in), and then displays the appropriate
'sign out' link. If a user is not signed in, then we show a 'sign in' and 
a 'register' links.

In this case, `link_to` is a ruby function, which take two parameters and an
optional third parameter. The first one is the text which will be displayed in
the link, the second one is the name of the path we want to invoke, and the 
third one is the http method we want to use, if the third parameter is not 
specified, rails will assume we mean "GET". The paths we specify can be
easily found by running (in terminal) `rake routes` and adding "\_path" to
the value in the left-most column for the path we want to link to.

Now, before we run the server, let's run `rake routes` to make sure that our
routes are set up correctly (it also doesn't hurt to run `rake db:migrate` to
make sure that our database is up-to-date), and we can start our server with a
simple `rails s` command.

With our server running, we can go to [http://localhost:3000/](http://localhost:3000)
and play around with our brand new app which now supports signing-in, signing-up and
registration.