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



