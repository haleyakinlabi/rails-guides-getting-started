
* Rails Guides

Getting Started with Rails!

Creating the Blog Application:

Step 1: rails new blog 

-This will create a Rails application called blog and will install the gem dependencies that are already mentioned in the Gemfile using bundle install 

Step 2: cd into the blog folder (cd blog) 

-The blog directory will have a number of generated files and folders that make up the structure of a Rails application. Most of the work in this tutorial will happen in the app folder, but here is the basic rundown on the function of each of the files and folders rails creates by default: 


File/Folder and Purpose
app/
Contains the controllers, models, views, helpers, mailers, channels, jobs, and assets for your application. You'll focus on this folder for the remainder of this guide
bin/
Contains the rails script that starts your app and can contain other scripts you use to set up, update, deploy, or run your application.
config/
Contains configuration for your application's routes, database, and more. This is covered in more detail in Configuring Rails Applications inside of the Rails Guides. 
config.ru 
Rack configuration for Rack-based servers used to start the application. For more information about Rack, see the Rack website.
db/ 
Contains your current database schema, as well as the database migrations.
Gemfile 
Gemfile.lock 
These files allow you to specify what gem dependencies are needed for your Rails application. These files are used by the Bundler gem. For more information about Bundler, see the Bundler website.
lib/ 
Extended modules for your application.
log/
Application log files.
public/ 
Contains static files and compiled assets. When your app is running, this directory will be exposed as-is.
Rakefile
This file locates and loads tasks that can be run from the command line. The task definitions are defined throughout the components of Rails. Rather than changing Rakefile, you should add your own tasks by adding files to the lib/tasks directory of your application.
README.md
This is a brief instruction manual for your application. You should edit this file to tell others what your application does, how to set it up, and so on.
storage/ 
Active Storage files for Disk Service. This is covered in Active Storage Overview.
test/
Unit tests, fixtures, and other test apparatus. These are covered in Testing Rails Applications.
tmp/
Temporary files (like cache and pid files)
vendor/
A place for all third-party code. In a typical Rails application this includes vendored gems.
.gitattributes 
This file defines metadata for specific paths in a git repository. This metadata can be used by git and other tools to enhance their behavior. See the gitattributes documentation for more information.
.gitignore
This file tells git which files (or patterns) it should ignore. See GitHub - Ignoring files for more information about ignoring files.
.ruby-version
This file contains the default Ruby version.

 
Step 3: start the Rails server (bin/rails server) 

-You actually already have a functional Rails application ready. To see it you need only start the server and type http://localhost:3000/ in the browser. 

Step 4: Say “Hello”, Rails 

-To get Rails saying “Hello”, you need to create at minimum a route, a controller with an action, and a view. 

-A route maps a request to a controller action. 

-A controller action performs the necessary work to handle the request, and prepares any data for the view. 

-A view displays data in a desired format 

-In terms of implementation: Routes are rules written in Ruby. Controllers are Ruby classes, and their public methods are actions. Views are templates, usually written in a mixture of HTML and Ruby

-Let’s start by adding a route to our routes file, config/routes.rb, at the top of the Rails.application.routes.draw block: 

Rails.application.routes.draw do 
  get “/articles”, to: “articles#index” 
end 

-The route above declares that GET /articles requests are mapped to the index action of the ArticlesController. 

-To create the ArticlesController and its index action, we’ll run the controller generator (with the –skip-routes option because we already have an appropriate route). Inside terminal type: 

bin/rail generate controller Articles index –skip-routes 

-Rails will create several files for you once you run the above command. The most important of these is the controller file, app/controllers/articles_controller.rb. Let’s take a look at it: 

class ArticlesController < ApplicationController 
  def index 
  end
end 

-The index action is empty. When an action does not explicitly render a view, Rails will automatically render a view that matches the name of the controller and action. Views are located in the app/views directory. So the index action will render app/views/articles/index.html.erb by default. 
-Let’s open app/views/articles/index.html.erb, and replace its contents with: 

<h1> Hello, Rails! </h1> 

Step 5: Setting the Application Home Page 

-At the moment, http://localhost:3000 still displays a page with the Ruby on Rails logo. Let’s display our “Hello, Rails!” instead. To do so, we will add a route that maps the root path of our application to the appropriate controller and action. 

-Open config/routes.rb, and add the following root route to the top of the Rails.application.routes.draw block: 

Rails.application.routes.draw do 
  root “articles#index” 
  get “/articles”, to: “articles#index” 
end 

-Now we can see our “Hello, Rails!” text when we visit http://localhost:3000 confirming that the root route is also mapped to the index action of ArticlesController. 

Step 6: Understanding Autoloading 

-Rails applications DO NOT use require to load application code. 

-Application classes and modules are available everywhere, you do neet and SHOULD NOT load anything under app with require. This feature is called autoloading, and you can learn more about it in Autoloading and Reloading Constants. 

-You only need require calls for two use cases: 
To load files under the lib directory
To load gem dependencies that have require: false in the Genfile 

Step 7: MVC and You 

-routes, controllers, actions, and views are all typical pieces of a web application that follows the MVC (Model, View, Controller) pattern. MVC is a design pattern that divides the responsibilities of an application to make it easier to reason about. 

-Since we have a controller and a view to work with, let’s generate the next piece: a model 

-A model is a Ruby class that is used to represent data. Additionally, models can interact with the application’s database through a feature of Rails called Active Record. 

-To define a model, we will use the model generator. Inside of your console type: 

bin/rails generate model Article title:string body:text 

-This will create several files, but the files we’ll want to focus on are migration file (db/migrate/<timestamp>_create_articles.rb) and the model file (app/models/article.rb) 

-Model names are singular, because an instantiated model represents a single data record. 

Step 8: Database Migrations 

-Migrations are used to alter the structure of an application’s database. In Rails applications, migrations are written in Ruby so that they can be database-agnostic. 

-Let’s take a look at the contents of our new migration file: 

class CreateArticles < ActiveRecord::Migration[7.0]
  def change 
    create_table :articles do |t| 
      t.string :title 
      t.text :body 

      t.timestamps 
    end 
  end
end

-The call to create_table specifies how the articles table should be constructed. By default, the create_table method adds an id column as an auto-incrementing primary key. 

-Inside the block for create_table, two columns are defined: title and body. These were added by the generator because we included them in our generate command. 

-On the last line of the block is a call to t.timestamps. This method defines two additional columns named created_at and updated_at. As we will see, Rails will manage these for us. 

-Let’s run our migration with the following command: 

bin/rails db:migrate 

-Now we can interact with the table using our model. 

Step 9: Using a Model to Interact with the Database 

-To play with our model a bit, we’re going to use a feature of Rails called the console. The console is an interactive coding environment like irb, but it also automatically loads Rails and our application code. 

-Launch the console with this command: 

bin/rails console 

-Now let’s initialize a new Article object: 

article = Article.new(title: “Hello Rails”, body: “I am on Rails”) 

-It’s important to note that we have only initialized this object. This object is not saved to the database at all. It’s only available inside of the console. To save the object to the database, we must call save:

article.save 

-Now let's take a look at the new article we just made: 

article 

-The id, created_at, and updated_at attributes of the object are now set. Rails did this for us when we saved the object. 

-When we want to fetch this article from the database, we can call find on the model and pass the id as an argument: 

Article.find(1) 

-And when we want to fetch all the articles from the database, we can call all on the model: 

Article.all 

Step 10: Showing a List of Articles 

-Let’s go back to our controller in app/controllers/articles_controller.rb, and change the index action to fetch all articles from the database: 

class ArticlesController < ApplicationController 
  def index 
    @articles = Article.all 
  end 
end 

-Controller instance variables can be accessed by the view. That means we can reference @articles in app/views/articles/index.html.erb. Let’s open that file, and replace its contents with: 

<h1> Articles </h1> 

<ul> 
  <% @articles.each do |article| %>
    <li>
      <%= article.title %> 
    </li> 
  <% end %> 
</ul> 

-The above code is a mixture of HTML and ERB. Here we have two types of ERB tags, <% %> and <%= %>. The <% %> tag means “evaluate the enclosed Ruby code, and output the value it returns”. Anything you could write in Ruby can go inside these ERB tags. <%= %> tags go around things you do want to output to the user. 

Step 11: CRUDit Where CRUDit is Due

-Almost all web applications involve CRUD (create, read, update, and delete) operations. Rails acknowledges this, and provides many features to help simplify code doing CRUD. 

-Let’s begin exploring these features by adding more functionality to our application.

-We currently have a view that lists all articles in our database. Let’s add a new view that shows the title and body of a single article. 

-We start by adding a new route that maps to a new controller action (which we will add next). Open config/routes.rb, and insert the last route shown here: 

Rails.application.routes.draw do 
  root “articles#index” 
  get “/articles”, to: “articles#index” 
  get “/articles/:id”, to: “articles#show” 
end 

-The new route is another get route, but it has something extra in its path: :id. This designates a route parameter. 

-A route parameter captures a segment of the request’s path, and puts that value into params Hash, which is accessible by the controller action. For example, when handling a request like GET http://localhost:3000/articles/1, 1 would be captured as the value for :id, which would then be accessible as params[:id] in the show action of ArticlesController. 

-Let’s add that show action now, below the index action in app/controller/articles_controller.rb: 

class ArticlesController < ApplicationController 
  def index 
    @articles = Article.all 
  end 
  def show 
    @article = Articles.find(parms[:id]) 
  end
end 

-The show action calls Article.find with the ID captured by the route parameter. The returned article is stored in the @article instance variable, so it is accessible by the view. By default, the show action will render app/views/articles/show.html.erb. 

-Let’s create app/views/articles/show.html.erb, with the following contents: 

<h1> <%= @article.title %> </h1> 
<p> <%= @article.body %> </p> 

-To finish up, let’s add a way to get to an article’s page. We’ll link each article’s title in app/views/articles/index.html.erb to its page: 

<h1> Articles </h1> 

<ul> 
  <% @articles.each do |article| %> 
    <li> 
      <a href= “/articles/<%= article.id %> 
        <%= article.title %> 
      </a>
    </li>
  <% end %> 
</ul> 
 
Step 12: Resourceful Routing 

-So far, we’ve covered the “R” (read) of CRUD. We will eventually cover all of the other letters. In order to do this we will be adding new routes, controller actions, and views. 

-Whenever we have such a combination of routes, controller actions, and views that work together to perform CRUD operations on an entity, we call that entity a resource. For example, in our application, we would say “article” is a resource. 

-Rails provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as articles. 

-Let’s replace the two get routes in config/routes.rb with resources: 

Rails.application.routes.draw do 
  root “articles#index” 
  resources :articles 
end 

-We can inspect what routes are mapped by running the (bin/rails routes) command. 

-The resources method also sets up URL and path helper methods that we can use to keep our code from depending on a specific route configuration. For example, the article_path helper returns “/articles/#{article:id}” when given an article. We can use it to tidy up our links in app/views/articles/index.html.erb: 

<h1> Articles </h1> 

<ul> 
  <% @articles.each do |article| %> 
    <li>
      <a href= “<%= article_path(article) %> >
        <%= article.title %>
      </a>
    </li>
  <% end %> 
</ul> 

-However, we can take this one step further by using the link_to helper. The link_to helper renders a link with its first argument as the link’s text and its second argument as the link’s destination. If we pass a model object as the second argument, link_to will call the appropriate path helper to convert the object to a path. For example, if we pass an article, link_to will call article_path. So app/views/articles/index.html.erb becomes: 

<h1> Articles </h1> 

<ul>
  <% @articles.each do |article| %> 
    <li>
      <%= link_to article.title, article %> 
    </li>
  <% end %> 
</ul>

Step 13: Creating a New Article (part 1) 

-Now we want to move onto the “C” (create) of CRUD. In web applications creating a new resource is a multi-step process. First the user requests a form to fill out. Then, the user submits the form. If there are no errors, then the resource is created and some kind of confirmation is displayed. Else, the form is redisplayed with error messages, and the process is repeated. 

-In a Rails application, these steps are typically handled by a controller’s new and create actions. Let’s add a typical implementation of these actions to app/controllers/articles_controller.rb, below the show action: 

Class ArticlesController < ApplicationController 
  def index 
    @articles = Articles.all 
  end 

  def show 
    @article = Article.find(params[:id]) 
  end

  def new
    @article = Article.new 
  end 

  def create 
    @article = Article.new(title: “...”, body: “...”) 
    if @article.save 
      redirect_to @article 
    else 
      render :new, status: :unprocessable_entity 
    end
  end 

end 

-The new action instantiates a new article, but does not save it. This article will be used in the view when building the form. By default, the new action will render app/views/articles/new.html.erb, which we will create next. 

-The create action instantiates a new article with values for the title and body, and attempts to save it. If the article is saved successfully, the action redirects the browser to the article’s page at “http://localhost:3000/articles/#{article.id}”. Else, the action redisplays the form by rendering 
app/views/articles/new.html.erb with a status code 422 Unprocessable Entity. The title and body here are dummy values. After we create the form we will come back and change these. 

-redirect_to will cause the browser to make a new request, whereas render renders the specified view for the current request. It’s important to use redirect_to after mutating the database or application state. Otherwise, if the user refreshes the page, the browser will make the same request, and the mutation will be repeated. 

Step 14: Using a Form Builder (creating a new article part 2) 

-We will use a feature of Rails called a form builder to create our form. Using a form builder, we can write a minimal amount of code to output a form that is fully configured. 

-Let’s create app/views/articles/new.html.erb with the following contents: 

<h1> New Article </h1> 

<%= form_with model: @article do |form| %> 

  <div>
    <%= form.label :title %> <br>
    <%= form.text_field :title %> 
  </div> 

  <div>
    <%= form.label :body %> <br> 
    <%= form.text_area :body %>
  </div> 

  <div>
    <%= form.submit %> 
  </div>

<% end %>  

-The form_with helper method instantiates a form builder. In the form_with block we call methods like label and text_field on the form builder to output the appropriate form elements. 

Step 14: Using Strong Parameters (creating a new article part 3)

-Submitted form data is put into the params Hash, alongside captured route parameters. Thus, create action can access the submitted title via params[:article][:title] and the submitted body via params[:article][:body]. We could pass these individually to Articles.new but that would be verbose. 

-Instead, we will pass a single Hash that contains the values. However, we must still specify what values are allowed in that Hash. Otherwise, a malicious user could potentially submit extra form fields and override private data. So we will use a feature of Rails called Strong Parameters to filter params. 

-Let’s add a private method to the bottom of app/controllers/articles_controller.rb named article_params that filters params. And let’s change create to use it: 

Class ArticlesController < ApplicationController 
  def index 
    @articles = Articles.all 
  end 

  def show 
    @article = Article.find(params[:id]) 
  end

  def new
    @article = Article.new 
  end 

  def create 
    @article = Article.new(article_params) 
    if @article.save 
      redirect_to @article 
    else 
      render :new, status: :unprocessable_entity 
    end
  end 

  private 
  
  def article_params 
    params.require(:article).permit(:title, :body)
  end 

end 

Step 15: Validations and Displaying Error Messages (creating a new article part 4)

-Rails provides a feature called validations to help us deal with invalid user input. Validations are rules that are checked before a model object is saved. If any of the checks fail, the save will be aborted, and appropriate error messages will be added to the errors attribute of the model object. 

-Let’s add some validations to our model in app/models/article.rb 

class Article < ApplicationRecord
  validates :title, presence: true 
  validates :body, presence: true, length: { minimum: 10 }  
end 

-The first validation declares that a title value must be present. 

-The second validation declares that a body value must also be present. Additionally, it declares that the body value must be at least 10 characters long.

-With our validations in place, let’s modify app/views/articles/new.html.erb to display any error messages for title and body: 

<h1> New Article </h1> 

<%= form_with model: @article do |form| %> 

  <div>
    <%= form.label :title %> <br>
    <%= form.text_field :title %>
    <% @article.errors.full_messages_for(:title).each do |message| %>
      <div> <%= message %> </div> 
    <% end %>  
  </div> 

  <div>
    <%= form.label :body %> <br> 
    <%= form.text_area :body %>
     <% @article.errors.full_messages_for(:body).each do |message| %>
      <div> <%= message %> </div> 
    <% end %> 
  </div> 

  <div>
    <%= form.submit %> 
  </div>

<% end %>  

-The full_messages_for method returns an array of user-friendly error messages for a specified attribute. If there are no errors for that attribute, the array will be empty. 

-To understand how this works together, let’s take another look at the new and create controller actions: 

def new 
  @article = Article.new 
end 

def create 
  @article = Articles.new(article_params)

  if @article.save 
    redirect_to @article
  else 
    render :new, status: :unprocessable_entity 
  end 
end

-When we visit http://localhost:3000/articles/new, the GET /articles/new request is mapped to the new action. The new action does not attempt to save @article. Therefore, validations are not checked, and there will be no error messages. 

-When we submit the form, the POST /articles request is mapped to the create action. The create action does attempt to save @article. Therefore, validations are checked. If any validation fails, @article will not be saved, and app/views/articles/new.html.erb will be rendered with error messages. 

-We can now create an article by visiting http://localhost:3000/articles/new. To finish up, let’s link to that page from the bottom of app/views/articles/index.html.erb: 

<h1> Articles </h1> 

<ul> 
  <% @articles.each do |article| %>
    <li>
      <%= link_to article.title, article %> 
    </li> 
  <% end %>
</ul>

<%= link_to “New Article”, new_article_path %> 

Step 16: Updating an Article (part 1) 

-We’ve now covered “CR” of CRUD. Now let’s move on to the “U” (update). Updating a resource is similar to creating a new resource. They are both multi-step processes. First, the user requests a form to edit the data. Then, the user submits the form. If there are no errors, then the resource is updated. Else, the form is redisplayed with error messages, and the process is repeated. 

-These steps are conventionally handled by a controller’s edit and update actions. Let’s add a typical implementation of these to app/controllers/articles_controller.rb, below the create action: 

def edit 
  @article = Article.find(params[:id]) 
end 

def update 
  @article = Article.find(params[:id]) 
  
  if @article.update(article_params) 
    redirect_to @article 
  else 
    render :edit, status: :unprocessable_entity 
  end 
end 

-The edit action fetches the article from the database, and stores it in @article so that it can be used when building the form. By default, the edit action will render app/views/articles/edit.html.erb. 

-The update action (re)fetches the article from the database, and attempts to update it with the submitted form data filtered by article_params. If no validations fail and the update is successful, the action redirects the browser to the article’s page. Else, the action redisplays the form with error messages by rendering app/views/articles/edit.html.erb. 

Step 17: Using Partials to Share View Code (updating an article part 2) 

-Our edit form will look the same as our new form. Even the code will be the same, thanks to the Rails form builder and resourceful routing. The form builder automatically configures the form to make the appropriate kind of request, based on whether the model object has been previously saved. 

-Because the code will look the same, we’re going to factor it out into a shared view called a partial. Let’s create app/views/articles/_form.html.erb with the following contents: 

<%= form_with model: article do |form| %> 

  <div>
    <%= form.label :title %> <br>
    <%= form.text_field :title %>
    <% article.errors.full_messages_for(:title).each do |message| %>
      <div> <%= message %> </div> 
    <% end %>  
  </div> 

  <div>
    <%= form.label :body %> <br> 
    <%= form.text_area :body %>
     <% article.errors.full_messages_for(:body).each do |message| %>
      <div> <%= message %> </div> 
    <% end %> 
  </div> 

  <div>
    <%= form.submit %> 
  </div>

<% end %>  

-The above code is the same as our form in app/views/articles/new.html.erb, except that all occurrences of @article have been replaced with article. Because partials are shared code, it is best practice that they do not depend on specific instance variables set by a controller action. Instead, we will pass the article to the partial as a local variable 

-Let’s update app/views/articles/new.html.erb to use the partial via render: 

<h1> New Article </h1> 

<%= render “form”, article: @article %> 

-A partial’s filename must be prefixed with an underscore. But when rendering, it is referenced without the underscore, e.g. render “form”. 

-Now let’s create a very similar app/views/articles/edit.html.erb: 

<h1> Edit Article </h1> 

<%= render “form”, article: @article %> 

-We can now update an article by visiting its edit page, e.g. http://localhost:3000/articles/1/edit. To finish up, let’s link the edit page from the bottom of app/views/articles/show.html.erb: 

<h1> <%= @article.title %> </h1> 

<p> <%= @article.body %> </p> 

<ul>
  <li>
    <%= link_to “Edit”, edit_article_path(@article) %> 
  </li>
</ul>

Step 18: Deleting an Article 

-Finally, we arrive at the “D” (delete) of CRUD. Deleting a resource is a simpler process than creating or updating. It only requires a route and a controller action. And our resourceful routing already provides the route, which maps DELETE /articles/:id requests to the destroy action of ArticlesController. 

-Let’s add a typical destroy action to app/controllers/articles_controller.rb, below the update action: 

def destroy 
  @article = Article.find(params[:id]) 
  @article.destroy 

  redirect_to root_path, status: :see_other
end 

-The destroy action fetches the article from the database, and calls destroy on it. Then, it redirects the browser to the root_path with status code 303 See Other. 

-We have chosen to redirect to the root path because that is our main access point for articles. But, in other circumstances, you might choose to redirect to e.g. articles_path.

-Now let’s add a link at the bottom of app/views/articles/show.html.erb so that we can delete an article from its own page: 

<h1> <%= @article.title %> </h1> 

<p> <%= @article.body %> </p> 

<ul>

  <li>
    <%= link_to “Edit”, edit_article_path(@article) %> 
  </li>

  <li>
    <%= link_to “Destroy”, article_path(@article), data: { turbo_method: :delete, turbo_confirm: 
    “Are you sure?” } %> 
  </li>
</ul>

-In the above code, we use the data option to set the data-turbo-method and data-turbo-confirm HTML attributes of the “Destroy” link. Both of these attributes look into Turbo, which is included by default in fresh Ruby applications. data-turbo-method = “delete” will cause the link to make a delete request instead of a GET request. data-turbo-confirm = “Are you sure?” will cause a confirmation dialog to appear when the link is clicked. If the user cancels the dialog, the request will be aborted. 

Step 19: Adding a Second Model

-It’s time to add a second model to the application. This model will handle comments on articles. 

-We will use the same generator as before when we created the Article model. This time we’ll create a Comment model to hold a reference to an Article. Run this command in your terminal: 

bin/rails generate model Comment commenter:string body:text article:references 

-Let’s take a look at app/models/comment.rb 

class Comment < ApplicationRecord 
  belongs_to :article 
end 

-This is similar to the article model. The difference is the line belongs_to :article, which sets up an Active Record association. You’ll learn a little about associations in the next section of this guide. 

-The (:references) keyword used in the shell command is a special data type for models. It creates a new column on your database table with the provided model name appended with an _id that can hold integer values. 

-In addition to the model, Rails has also make a migration to create the corresponding database table: 

class CreateComments < ActiveRecord::Migration[7.0] 
  def change 
    create_table :comments do |t| 
      t.string :commenter 
      t.text :body 
      t.references :article, null: false, foreign_key: true 

      t.timestamps
    end 
  end 
end 

-The t.references line creates an integer column called article_id, an index for it, and a foreign key constraint that points to the id column of the articles table. Go ahead and run the migration: 

bin/rails db:migrate 

-Active Record associations let you easily declare the relationship between two models. In the case of comments and articles, you could write out relationships this way: 

Each comment belongs to one article.  
One article can have many comments. 

-This is close to the syntax Rails uses to declare this association. You’ve seen it inside of app/models/comment.rb that makes each comment belong to an Article: 

class Comment < ApplicationRecord 
  belongs_to :article 
end 

-You’ll need to edit app/models/article.rb to add the other side of the association: 

class Article < ApplicationRecord 
has_many :comments 

validates :title, presence: true
validates :body, presence: true, length: { minimum: 10 } 
end 

-These two declarations enable a good bit of automatic behavior. For example, if you have an instance variable @article containing an article, you can retrieve all the comments belonging to that article as an array using @article.comments. 

Step 20: Adding a Route for Comments 

-Open up the config/routes.rb file again, and edit it as follows: 

Rails.application.routes.draw do 
  root “articles#index” 

  resources :articles do
    resources :comments 
  end
end 

-This creates comments as a nested resource within articles. This is another part of capturing the hierarchical relationship that exists between articles and comments. 

Step 21: Generating a Controller 

-With the model in hand, we can turn our attention to making a matching controller. We’ll use the same generator we used before: 

bin/rails generate controller Comments 

-Like with any blog, our readers will create their comments directly after reading the article, and once they have added their comment, will be sent back to the article show page to see their comment listed. Due to this our CommentsController is there to provide a method to create comments and delete spam comments when they arrive. 

-First we’ll wire up the Article show template (app/views/articles/show.html.erb) to let us make a new comment: 

<h1> <%= @article.title %> </h1> 

<p> <%= @article.body %> </p> 

<ul>

  <li>
    <%= link_to “Edit”, edit_article_path(@article) %> 
  </li>

  <li>
    <%= link_to “Destroy”, article_path(@article), data: { turbo_method: :delete, turbo_confirm: 
    “Are you sure?” } %> 
  </li>
</ul>

<h2> Add a comment: </h2> 
<%= form_with model: [ @article, @article.comments.build ] do |form| %> 

  <p>
    <%= form.label :commenter %> <br> 
    <%= form.text_field :commenter %> 
  </p>
  <p>
    <%= form.label :body %> <br> 
    <%= form.text_area :body %> 
  </p>
  <p>
    <%= from.submit %> 
  </p>

<% end %> 

-This adds a form on the Article show page that creates a new comment by calling the CommentsController create action. The form_with call here uses an array, which will build a nested route, such as /articles/1/comments. 

-Let’s wire up the create in app/controllers/comments_controller.rb: 

class CommentsController < ApplicationController 
  def create 
    @article = Article.find(params[:article_id]) 
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article) 
  end 

  private 

  def comment_params 
    params.require(:comment).permit(:commenter, :body)
  end 
end 

-You’ll see a bit more complexity here than in the ArticlesController. That’s a side-effect of the nesting we’ve set up. Each request for a comment has to keep track of the article to which the comment is attached, thus the initial call to the find method of the Article model to get the article in question. 

-In addition, the code takes advantage of some of the methods available for an association. We use the create method on @article.comments to create and save the comment. This will automatically link the comment so that it belongs to that particular article. 

-Once we have made the new comment, we send the user back to the original article using the article_path(@article) helper. As we have already seen, this calls the show action of the ArticlesController which in turn renders the show.html.erb template. This is where we want the comments to show, so let’s add that to the app/views/articles/show.html.erb underneath the <ul></ul> add: 

<h2> Comments </h2> 
<%= @article.comments.each do |comment| %> 
  <p>
    <strong> Commenter: </strong> 
    <%= comment.commenter %> 
  </p>
  <p>
    <strong> Comment: </strong> 
    <%= comment.body%>
  </p>
<% end %> 

Step 22: Refactoring 

-Our app/views/articles/show.html.erb is getting long and awkward. We can use partials to clean it up. 

-First, we’ll make a comment partial to extract showing all the comments for the article. Create the file app/views/comments/_comment.html.erb and put the following into it: 

<p>
  <strong> Commenter: </strong> 
  <%= comment.commenter %> 
</p>
<p>
  <strong> Comment: </strong> 
  <%= comment.body %> 
</p>

-Then you can change app/views/articles/show.html.erb to look like the following: 

<h1> <%= @article.title %> </h1> 

<p> <%= @article.body %> </p> 

<ul>

  <li>
    <%= link_to “Edit”, edit_article_path(@article) %> 
  </li>

  <li>
    <%= link_to “Destroy”, article_path(@article), data: { turbo_method: :delete, turbo_confirm: 
    “Are you sure?” } %> 
  </li>
</ul>

<h2> Comments </h2> 
<%= render @article.comments %> 

<h2> Add a comment: </h2> 
<%= form_with model: [ @article, @article.comments.build ] do |form| %> 

  <p>
    <%= form.label :commenter %> <br> 
    <%= form.text_field :commenter %> 
  </p>
  <p>
    <%= form.label :body %> <br> 
    <%= form.text_area :body %> 
  </p>
  <p>
    <%= from.submit %> 
  </p>

<% end %>

-This will now render the partial in app/views/comments/_comment.html.erb once for each comment that is in the @article.comments collection. As the render method iterates over the @articles.comments collection, it assigns each comment to a local variable named the same as the partial, this this case comment, which is then available in the partial for us to show. 

-Let us also move that new comment section out and into its own partial. Again, you create a file app/view/comments/_form.html.erb containing: 

<%= form_with model: [ @article, @article.comments.build ] do |form| %> 

  <p>
    <%= form.label :commenter %> <br> 
    <%= form.text_field :commenter %> 
  </p>
  <p>
    <%= form.label :body %> <br> 
    <%= form.text_area :body %> 
  </p>
  <p>
    <%= from.submit %> 
  </p>

<% end %>

-Then you make the app/views/articles/show.html.erb look like the following: 

<h1> <%= @article.title %> </h1> 

<p> <%= @article.body %> </p> 

<ul>

  <li>
    <%= link_to “Edit”, edit_article_path(@article) %> 
  </li>

  <li>
    <%= link_to “Destroy”, article_path(@article), data: { turbo_method: :delete, turbo_confirm: 
    “Are you sure?” } %> 
  </li>
</ul>

<h2> Comments </h2> 
<%= render @article.comments %> 

<h2> Add a comment: </h2> 
<%= render ‘comments/form’ %> 

-The second render just defines the partial template we want to render, comments/form. Rails is smart enough to spot the forward slash in that string and realize that you want to render _form.html.erb. 

-The @article object is available to any partials rendered in the view because we defined it as an instance variable. 

Step 23: Using Concerns 

-Concerns are a way to make large controllers or models easier to understand and manage. This also has the advantage of reusability when multiple models or controllers share the same concerns. 

-Concerns are implemented using modules that contain methods representing a well-defined slice of the functionality that a model or controller is responsible for. 

-You can use concerns in your controller or model the same way you would use any module. When we created our app with rails new blog, two folders were created within app/ along with the rest 
app/controllers/concerns 
app/models/concerns 

-Let’s try using a concern. A blog article might have various statuses – for instance, it might be visible to everyone (i.e. public), or only visible to the author (i.e. private). It may also be hidden to all but still retrievable (i.e. archived). Comments may similarly be hidden or visible. This could be represented using a status column in each model. 

-First let’s run the following migrations to add status to Articles and Comments: 

bin/rails generate migration AddStatusToArticles status:string 
bin/rails generate migration AddStatusToComments status:string 

-Next, let’s update the database with the generated migrations: 

bin/rails db:migrate 

-We also have to permit the :status key as part of the strong parameter, in app/controllers/articles_controller.rb: 

private 

  def article_params
    params.require(:article).permit(:title, :body, :status)  
  end

-And in app/controllers/comments_controller.rb 
private 
 
  def comment_params 
    params.require(:comment).permit(:commenter, :body, :status)
  end

-Within the article model, after running a migration to add a status column using bin/rails db:migrate command, you would add: 

class Article < ApplicationRecord 
  has_many :comments 

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  VALID_STATUSES = [‘public’, ‘private’, ‘archived’]

  validates :status, inclusion: { in: VALID_STATUSES } 

  def archived? 
    status === ‘archived’
  end
end

-And in the comment model: 

class Comments< ApplicationRecord 
  belongs_to :article 

  VALID_STATUSES = [‘public’, ‘private’, ‘archived’]

  validates :status, inclusion: { in: VALID_STATUSES } 

  def archived? 
    status === ‘archived’
  end
end

-Then in our index action template (app/views/articles/index.html.erb) we would use the archived? method to avoid displaying any article that is archived: 

<h1> Articles </h1> 

<ul> 
  <% @articles.each do |article| %> 
    <%= unless article.archived? %> 
      <li>
        <%= link_to article.title, article %> 
      </li> 
    <% end %> 
  <% end %> 
</ul>

<%= link_to “New Article”, new_article_path %> 

-Similarly, in our comment partial view (app/views/comments/_comment.html.erb) we would use the archived? method to avoid displaying any comment that is archived: 

<% unless comment.archived? %> 
  <p>
    <strong> Commenter: </strong> 
    <%= comment.commenter %> 
  </p>
  <p>
    <strong> Comment: </strong> 
    <%= comment.body %> 
  </p>
<% end %> 

-However, if you look again at our modules now, you can see that the logic is duplicated. If in the future we increase the functionality of our blog - to include private messages, for instance - we might find ourselves duplicating the logic once again. This is where concerns come in handy. 

-A concern is only responsible for a focused subset of the model’s responsibility; the methods in our concern will all be related to the visibility of a model. Let’s call our new concern (module) Visible. We can create a new file inside app/models/concerns called visible.rb, and store all of the status methods that were duplicated in the models. 

module Visible 
  def archived? 
    status === ‘archived’ 
  end 
end 

-We can add our status validation to the concern, but this is more complex as validations are methods called at the class level. The Active:Support::Concern gives us a simpler way to include them: 

module Visible
  extend ActiveSupport::Concern
 
  VALID_STATUSES = [‘public’, ‘private’, ‘archived’]
  included do 
    validates :status, inclusion: { in: VALID_STATUSES } 
  end 

  def archived? 
    status === ‘archived’ 
  end 
end 

-Now, we can remove the duplicated logic from each model and instead include our new Visible module. 

-In app/models/articles.rb: 

class Article < ApplicationRecord 
  include Visible 

  has_many :comments 

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  end

-And in app/models/comment.rb: 

class Comments< ApplicationRecord 
  include Visible

  belongs_to :article 

end

-Class methods can also be added to concerns. If we want to display a count of public articles or comments on our main page, we might add a class method to Visible as follows: 

module Visible
  extend ActiveSupport::Concern
 
  VALID_STATUSES = [‘public’, ‘private’, ‘archived’]
  included do 
    validates :status, inclusion: { in: VALID_STATUSES } 
  end 

  class_methods do
    def public_count 
      where(status: ‘public’).count  
    end  
  end 

  def archived? 
    status === ‘archived’ 
  end 
end 

-Then in the view (app/views/articles/index.html.erb), you can call it like any class method: 

<h1> Articles </h1>

Our blog has <% Article.public_count %> articles and counting!  

<ul> 
  <% @articles.each do |article| %> 
    <%= unless article.archived? %> 
      <li>
        <%= link_to article.title, article %> 
      </li> 
    <% end %> 
  <% end %> 
</ul>

<%= link_to “New Article”, new_article_path %> 

-To finish up, we will add a select box to the forms, and let the user select the status when they create a new article or post a new comment. We can also specify the default status as public. In app/views/articles/_form.html.erb, we can add: 

<div> 
  <%= form.label :status %> <br> 
  <%= form.select :status, [‘public’, ‘private’, ‘archived’], selected: ‘public’ %> 
</div> 

-And in app/views/comments/_form.html.erb: 

<p> 
  <%= form.label :status %> <br> 
  <%= form.select :status, [‘public’, ‘private’, ‘archived’], selected: ‘public’ %> 
</p> 

Step 24: Deleting Comments 

-Another important feature of a blog is being able to delete spam comments. To do this we need to implement a link of some sort in the view and a destroy action in the CommentsController. 

-First let’s add the delete link in app/views/comments/_comment.html.erb partial: 

<% unless comment.archived? %> 

  <p>
    <strong> Commenter: </strong> 
    <%= comment.commenter %> 
  </p>
  <p>
    <strong> Comment: </strong> 
    <%= comment.body %> 
  </p>
  <p>
      <%= link_to “Destroy Comment”, 
      [comment.article, comment], 
      data: { trubo_method: :delete, turbo:confirm: “Are you sure?” } %>  
  </p>

<% end %> 

-Clicking the new “Destroy Comment” link will fire off a DELETE/articles/:article_id/comments/:id to our CommentsController, which can then use this to find the comment we want to delete, so let’s add a destroy action to our controller (app/controllers/comments_controller.rb): 

def destroy 
  @article = Article.find(params[:article_id]) 
  @comment = @article.comments.find(params[:id]) 
  @comment.destroy 
  redirect_to article_path(@article), status: :see_other 
end 

-The destroy action will find the article we are looking at, locate the comment within the @article.comments collection, and then remove it from the database and send us back to the show action for the article. 

Step 25: Deleting Associated Objects 

-if you delete an article, its associated comments will also need to be deleted, otherwise they would simply occupy space in the database. Rails allows you to use the dependent option of an association to achieve this. Modify the Article model, (app/models/article.rb), as follows: 

class Article < ApplicationRecord 
  include Visible 

  has_many :comments, dependent: :destroy 

  validates :title, presence: true 
  validates :body, presence: true, length: { minimum: 10 } 
end 


Step 26: Basic Authentication (security part 1)

-If we were to publish this app as is, anyone would be able to add, edit and delete articles or comments. 

-Rails provides an HTTP authentication system that will work nicely in this situation. 

-In the ArticlesController, we need to have a way to block access to the various actions if the person is not authenticated. Here we can use the Rails http_basic_authenticate_with 
method, which allows access to the requested action if that method allows it. 

-To use the authentication system, we specify it at the top of our ArticlesController in app/controllers/articles_controller.rb. In our case, we want the user to be authenticated on every action except index and show, so we write that: 

class ArticlesController < ApplicationController 

http_basic_authenticate_with name: “dhh”, password: “secret”, 
except: [:index, :show]

…

-We also want to allow only authenticated users to delete comments, so in the CommentsController (app/controllers/comments_controller.rb) we write: 

http_basic_authenticate_with name: “dhh”, password: “secret”, 
only: :destroy 

…

-Now if you try to create a new article, you will be greeted with a basic HTTP Authentication challenge. 

-Other authentication methods are available for Rails applications. Two popular authenticated add-ons for Rails are the Devise rails engine and the Authlogic gem, along with a number of others. 

-Look at the Rails Security Guide for more information about security. 







