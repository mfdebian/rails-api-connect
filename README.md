# Connect to an external API using CRUD operations

A step by step guide with an example to manually create a project that
connects to an external service using HTTP to perform the basic CRUD
operations

## Create project

`rails new project`

`cd project`

## Generate route

_config/routes.rb_

`resource :users`

## Generate controller

`rails generate controller Users`

_optional: also add `root "users#index"` to config file for root route_


## Generate Model

`rails generate model User name:string username:string email:string phone:string website:string`

## Run the migration

`rails db:migrate`

## Add a record via console

`rails c`

```rb
user = User.new(
  name: "Robert",
  username: "robertitou",
  email: "robert@email.com",
  phone: "555 34 22",
  website: "robert.cl")
```

`user.save`

## Add index to controller

*app/controllers/users_controller.rb*

```rb
def index
  @users = User.all
end
```

## Render index

_app/views/users/index.html.erb_

```erb
<h1>Users</h1>

<% if @users.present? %>
  <ul>
    <% @users.each do |user| %>
      <li>
        <strong>Full name:</strong>
        <%= user.name %>
      </li>
      <li>
        <strong>Username:</strong>
        <%= user.username %>
      </li>
      <li>
        <strong>Email:</strong>
        <%= user.email %>
      </li>
      <li>
        <strong>Phone number:</strong>
        <%= user.phone %>
      </li>
      <% if user.website.present? %>
        <li>
          <strong>Personal website:</strong>
          <%= user.website %>
        </li>
      <% end %>
    <% end %>
  </ul>
<% else %>
  <p>No users found.</p>
<% end %>
```

## Rest of CRUD operations

### show

*app/controllers/users_controller.rb*

```rb
def show
  @user = User.find(params[:id])
end
```

_app/views/users/index.html.erb_

```erb
<h1>Users</h1>

<ul>
  <% @users.each do |user| %>
    <li>
      <%= link_to user.name, user %>
    </li>
  <% end %>
</ul>
```

_app/views/users/show.html.erb_

```erb
<li>
  <strong>Full name:</strong>
  <%= @user.name %>
</li>
<li>
  <strong>Username:</strong>
  <%= @user.username %>
</li>
<li>
  <strong>Email:</strong>
  <%= @user.email %>
</li>
<li>
  <strong>Phone number:</strong>
  <%= @user.phone %>
</li>
<% if @user.website.present? %>
  <li>
    <strong>Personal website:</strong>
    <%= @user.website %>
  </li>
<% end %>

<div>
  <%= link_to "Back to users", users_path %>
</div>
```

### create

*app/controllers/users_controller.rb*

```rb
def new
  @user = User.new
end

def create
  @user = User.new(user_params)

  if @user.save
    redirect_to @user
  else
    render :new, status: :unprocessable_entity
  end
end

private
  def user_params
    params.require(:user).permit(:name, :username, :email, :phone, :website)
  end
```

_app/views/users/new.html.erb_

```erb
<h1>New User</h1>

<%= form_with model: @user do |form| %>
  <div>
    <%= form.label "Full name", style: "display: block" %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label "Username", style: "display: block" %>
    <%= form.text_field :username %>
  </div>

  <div>
    <%= form.label "Email", style: "display: block" %>
    <%= form.text_field :email %>
  </div>

  <div>
    <%= form.label "Phone number", style: "display: block" %>
    <%= form.text_field :phone %>
  </div>

  <div>
    <%= form.label "Personal website", style: "display: block" %>
    <%= form.text_field :website %>
  </div>

  <div>
    <br/>
    <%= form.submit "Save user" %>
  </div>
<% end %>
```

### Add validations

_app/models/user.rb_

```rb
class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :username, presence: true, length: { minimum: 4, maximum: 25 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
end
```

_app/views/users/new.html.erb_

```erb
<h1>New User</h1>

<%= form_with(model: @user) do |form| %>
  <% if @user.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(@user.errors.count, "error") %> prohibited this user from being saved:</h2>

      <ul>
        <% @user.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= form.label "Full name", style: "display: block" %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label "Username", style: "display: block" %>
    <%= form.text_field :username %>
  </div>

  <div>
    <%= form.label "Email", style: "display: block" %>
    <%= form.text_field :email %>
  </div>

  <div>
    <%= form.label "Phone number", style: "display: block" %>
    <%= form.text_field :phone %>
  </div>

  <div>
    <%= form.label "Personal website", style: "display: block" %>
    <%= form.text_field :website %>
  </div>

  <div>
    <br/>
    <%= form.submit "Save user" %>
  </div>
<% end %>
```

_app/views/users/index.html.erb_

```erb
<h1>Users</h1>

<ul>
  <% @users.each do |user| %>
    <li>
      <%= link_to user.name, user %>
    </li>
  <% end %>
</ul>

<%= link_to "New User", new_user_path %>
```

### update

```rb
def edit
  @user = User.find(params[:id])
end

def update
  @user = User.find(params[:id])

  if @user.update(user_params)
    redirect_to @user
  else
    render :edit, status: :unprocessable_entity
  end
end
```

create partial view *app/views/users/_form.html.erb*

```erb
<%= form_with(model: @user) do |form| %>
  <% if @user.errors.any? %>
    <div style="color: red">
      <h2><%= pluralize(@user.errors.count, "error") %> prohibited this user from being saved:</h2>

      <ul>
        <% @user.errors.each do |error| %>
          <li><%= error.full_message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div>
    <%= form.label "Full name", style: "display: block" %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label "Username", style: "display: block" %>
    <%= form.text_field :username %>
  </div>

  <div>
    <%= form.label "Email", style: "display: block" %>
    <%= form.text_field :email %>
  </div>

  <div>
    <%= form.label "Phone number", style: "display: block" %>
    <%= form.text_field :phone %>
  </div>

  <div>
    <%= form.label "Personal website", style: "display: block" %>
    <%= form.text_field :website %>
  </div>

  <div>
    <br/>
    <%= form.submit "Save user" %>
  </div>
<% end %>
```

_app/views/users/edit.html.erb_

```erb
<h1>Edit User</h1>

<%= render "form", user: @user %>

<br />

<div>
  <%= link_to 'Back', user_path %>
</div>
```

_app/views/users/new.html.erb_

```erb
<h1>Add User</h1>

<%= render "form", user: @user %>

<br />

<div>
  <%= link_to "Back to users", users_path %>
</div>
```
_app/views/users/show.html.erb_

```erb
<main>
  <ul>
    <li>
      <strong>Full name:</strong>
      <%= @user.name %>
    </li>
    <li>
      <strong>Username:</strong>
      <%= @user.username %>
    </li>
    <li>
      <strong>Email:</strong>
      <%= @user.email %>
    </li>
    <li>
      <strong>Phone number:</strong>
      <%= @user.phone %>
    </li>
    <% if @user.website.present? %>
      <li>
        <strong>Personal website:</strong>
        <%= @user.website %>
      </li>
    <% end %>
  </ul>

  <div>
    <%= link_to 'Edit user', edit_user_path(@user) %>
  </div>
  <br />
  <div>
    <%= link_to "Back to users", users_path %>
  </div>
</main>
```

### destroy

_app/controllers/users_controller.rb_

```rb
def destroy
  @user = User.find(params[:id])
  @user.destroy

  redirect_to root_path, status: :see_other
end
```

_app/views/users/show.html.erb_

```erb
<main>
  <ul>
    <li>
      <strong>Full name:</strong>
      <%= @user.name %>
    </li>
    <li>
      <strong>Username:</strong>
      <%= @user.username %>
    </li>
    <li>
      <strong>Email:</strong>
      <%= @user.email %>
    </li>
    <li>
      <strong>Phone number:</strong>
      <%= @user.phone %>
    </li>
    <% if @user.website.present? %>
      <li>
        <strong>Personal website:</strong>
        <%= @user.website %>
      </li>
    <% end %>
  </ul>

  <div>
    <%= link_to 'Edit user', edit_user_path(@user) %>
  </div>
  <br />
  <div>
    <%= link_to 'Delete user', user_path(@user),
      data: {
        turbo_method: :delete,
        turbo_confirm: "Are you sure?"
      }
    %>
  </div>
  <br />
  <div>
    <%= link_to "Back to users", users_path %>
  </div>
</main>
```

## Connect with external API

create service *app/services/users_service.rb*

### read

*users_service.rb*

```rb
require 'net/http'
require 'json'

class UsersService
  BASE_URL = 'https://jsonplaceholder.typicode.com/users'

  def self.call
    url = URI.parse(BASE_URL)
    response = Net::HTTP.get_response(url)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end
end
```

_app/controllers/users_controller.rb_

```rb
def index
  users_from_api = UsersService.call

  users_from_api.each do |api_user|
    user = User.find_or_initialize_by(id: api_user['id'])
    user.update(
      name: api_user['name'],
      username: api_user['username'],
      email: api_user['email'],
      phone: api_user['phone'],
      website: api_user['website']
    )
  end

  @users = User.all
end
```

### create

*users_service.rb*

```rb
def self.create(user_params)
  url = URI.parse(BASE_URL)
  http = Net::HTTP.new(url.host)
  request = Net::HTTP::Post.new(url.path, {'Content-Type' => 'application/json'})
  request.body = user_params.to_json

  response = http.request(request)

  JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
end
```

_app/controllers/users_controller.rb_

```rb
def create
  user_data = UsersService.create(user_params)

  @user = User.new(
    name: user_data['name'],
    username: user_data['username'],
    email: user_data['email'],
    phone: user_data['phone'],
    website: user_data['website']
  )

  respond_to do |format|
    if @user.save
      format.html { redirect_to user_url(@user) }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end
```

### update

*users_service.rb*

```rb
def self.update(user, user_params)
  # faking the id for the API
  url = URI.parse("#{BASE_URL}/1")
  http = Net::HTTP.new(url.host)
  request = Net::HTTP::Put.new(url.path, {'Content-Type' => 'application/json'})

  request.body = user_params.to_json

  response = http.request(request)

  parsed_response = JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

  # returning our user's id
  parsed_response['id'] = user.id

  parsed_response
end
```

*app/controllers/users_controller.rb*

add before action at the top:
`before_action :set_user, only: [:show, :edit, :update, :destroy]`

and declare inside private properties:
```rb
def set_user
  @user = User.find(params[:id])
end
```

```rb
def update
  updated_user_data = UsersService.update(@user, user_params)

  respond_to do |format|
    if @user.update(
        name: updated_user_data['name'],
        username: updated_user_data['username'],
        email: updated_user_data['email'],
        phone: updated_user_data['phone'],
        website: updated_user_data['website']
      )
      format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
      format.json { render :show, status: :ok, location: @user }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end
```

### destroy

*users_service.rb*

```rb
def self.destroy(id)
  # faking the id for the API
  url = URI.parse("#{BASE_URL}/1")
  http = Net::HTTP.new(url.host)
  request = Net::HTTP::Delete.new(url.path, {'Content-Type' => 'application/json'})

  response = http.request(request)

  if response.is_a?(Net::HTTPSuccess)
    { status: 200, message: "Deleted user with id #{id}" }
  else
    { status: response.code.to_i, message: "Failed to delete user with id #{id}" }
  end
end
```

*app/controllers/users_controller.rb*

```rb
def destroy
  @user = User.find(params[:id])
  response = UsersService.destroy(@user.id)

  if response[:status] == 200
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: response[:message] }
      format.json { head :no_content }
    end
  else
    respond_to do |format|
      format.html { redirect_to users_url, alert: response[:message] }
      format.json { render json: { error: response[:message] }, status: :unprocessable_entity }
    end
  end
end
```

## Done!