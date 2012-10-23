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


