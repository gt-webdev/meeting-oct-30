What's on your mind?
=====================

Continuing from last week's meeting (sources are available 
[here](git@github.com:gt-webdev/meeting-oct-23.git)), we'll be working with our
**awesome** and **original** social networking site: `bookface`. This week 
we'll discuss setting up relations between your models as we implement statuses.

Statuses are, of course, short messages that users on our site can share with 
their friends. The implementation we'll use for statuses will show how rails
uses models and controllers to easily "link" between the objects we use in our
app and present them in a sensible way.

# Instructions

## Catching up with Bookface

The instructions in this document expect you to have already completed last 
weeks tutorial. If you haven't you can 'cheat' by cloning the final repository
from last week's meeting. Doing so is as easy as:

    git clone https://github.com/gt-webdev/meeting-oct-23.git

You'll probably want to make sure that you're in a folder where you'd like the
project folder to be created.

## the 'resources' function

So far our config/routes.rb file doesn't contain too much. We already invoked
the `devise` function for `:users` which set up the routes needed to create and
use the user-objects which manages user-authentication. Now we're going to do
a similar thing with the `users_controller` that we created last week.

What we're going to do is use the `resources` function which rails provide us.
This function takes the name of a controller and maps specific paths and 
methods to functions in the corresponding `_controller.rb` file. These paths
and methods follow a common convention and can be changed later. Now, we're 
going to change our `config/routes.rb` file so that it looks like this:

```ruby
Bookface::Application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index] # add this line to your routes.rb file!
  root :to => 'users#index'
# Comments have been removed for the sake of readability
end
```

Normally, just adding `resources :users` would be used. This would go ahead and 
create routes that would be used for creating new users, deleting old ones, 
modifying users, and so on. In this case, we have devise manage these actions
so we only need to add functionality to `show` a single user, and to show the
app's main page (which is also mapped to "/" by the next line in the file).

If you remember correctly, we only created an `index` folder in
`app/controllers/users_controller.rb`, if we don't want rails to give us an
error, we'll need to create a similar function for show.

Add the follwing function into the users_controller.rb file:

```ruby
def show
  @user = User.find(params[:id])
end
```

This function will be invoked when someone goes to `/users/:id` and it will pass
local variable to a corresponding views file. In this case we're creating a
variable named `@user` which will contain the user which is returned from 
"searching" with the user_id which was a parameter in our path.

The last thing we need to make this work is create the views file for the 
function. The file will need to be placed in the views folder for `users`
and be named after the function. So create a file, 
`app/views/users/show.html.erb`, and place the following code in it.

```erb
<h1><%= @user.first_name %> <%= @user.last_name %></h1>
```

This file just reads the `first_name` and `last_name` fields off of the user
we passed to the view from our `show` function and presents them as a heading.

We can test everything we did so far by running `rake routes` followed by 
`rails s`. If you have a user set-up, you could just go to 
(localhost:3000/users/1)[localhost:3000/users/1], otherwise you will need to create a user first.

All that's left to do is find a way to make it easier for users to get to
their profile page. The easiest way would be to add a "My profile" link to
the template layout for our site. Open `app/views/layout/application.html.erb`
and add the following link to the page next to the links for "sign out":

```erb
<%= link_to "My Profile", user_path(current_user) %>
```

Now if you refresh the page or go to (localhost:300)[localhost:3000] while 
logged in, you will see a "My Profile" link at the top.

## Models

Last week we created a model for `user`. But we did this through the `devise`
gem. The main reason for doing so was because devise helped us by creating all
sorts of files that contain the code needed to securely manage user accounts.
This week, we want to create a new Model for the statuses that user can post.

Generally, Models take on the role of storing (and managing) data. In most cases
when you want data to be saved (e.g. the names of your users, the posts that 
they make, etc.) you'll need to place this data in an appropriate model.

Generating the model should seem familiar:

    # rails g model status text:string user_id:integer
    # rake db:migrate
    # rails g controller statuses

With this we generated the model and controller for statuses. Now we'll need
to add some content to the file we generated.

First off, we'll modify the `app/models/status.rb` file. This file is relatively 
simple. we only need to use a function to indicate that the status objects belongs
to users.

```ruby
class Status < ActiveRecord::Base
  belongs_to :user
  attr_accessible :text, :user_id
end
```

A corresponding addition needs to be made to the `users.rb` file:

```ruby
  has_many :statuses
```

The controller file is a little bit more complicated:

```ruby
class StatusesController < ApplicationController
  def create
    @status = current_user.statuses.create params[:status]
    redirect_to user_path params[:user_id]
  end
  def destroy
    @status = current_user.statuses.find params[:id]
    @status.destroy
    redirect_to user_path params[:user_id]
  end
end
```

We're defining two methods. One that creates statuses and one that removes them.
These statuses will need to be mapped to routes, but you can already see that
we'll need to see which user owns this status since we make use of the 
`:user_id` parameter.

Now let's add these functions to our config/routes.rb file:

```ruby
Bookface::Application.routes.draw do
  devise_for :users
  resources :users, only: [:show, :index] do
    resources :statuses, only: [:create, :destroy]
  end
  root :to => 'users#index'
end
```

Notice that we added the routes using the same `resources` function as before
although we "chained" it at the end of the previous call for `:user`. This
effectively places the paths as a subset of the user path, so we'll need
to specify a :user_id in our url before we specify the :id for the status
we want to modify.

At this point we can run `rake routes` to save the changes we made to the app
in our `routes.rb` file.

Now, all that's left to do is modify our show-user view to show statuses, this
requires a bit of erb, but not much we haven't seen before:

```erb
<h1><%= @user.first_name %> <%= @user.last_name %></h1>

<%= form_for [current_user, @status] do |f| %>
  <%= f.label 'status' %>
  <%= f.text_field :text %>

  <%= f.submit %>

<% end %>

<ul>
<%= @statuses.each do |status| %>
  <li><%= status.text %>
  <%= link_to "DELETE", user_status_path(user_id: current_user, id: status), method: :delete %>
  </li>
<% end %>
</ul>
```

The first part is a simple form that should be relatively intuitive, and 
the second part is a quick list with special "DELETE" links that will 
remove statuses from the database.

And since we modified the view to deal with a new variable `@statuses` we'll
probably want to add this to our `show` method in our users_controller.rb:

```ruby
def show
  @user = User.find(params[:id])
  @status = current_user.statuses.build
  @statuses = @user.statuses
end
```

The first variable we added `@status` creates an empty status object which
we`ll save new data into if the user chooses to create a status with the
form we provided. The second variable contains a list of all the statuses
associated with a user.

Now, we can save our files and run `rails s` and start using statuses!

