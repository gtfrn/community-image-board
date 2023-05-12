# Import the necessary libraries
import urbit
import time

# Create a new Urbit app
app = urbit.App()

# Define the app's routes
@app.route("/")
def index():
  # Get the current user's ship
  ship = urbit.ship()

  # Get the list of all images that have been posted to the board
  images = app.get("/images")

  # Render the index page, with the list of images
  return urbit.render("index.html", images=images)

@app.route("/post")
def post():
  # Get the current user's ship
  ship = urbit.ship()

  # Get the image that the user is trying to post
  image = urbit.request.files["image"]

  # Check to see if the user is allowed to post an image
  if time.time() - app.get("/last_post_time/{}".format(ship)) < 18 * 3600:
    return urbit.render("error.html", message="You can't post an image yet.")

  # Save the image to the board
  app.put("/images/{}".format(image.filename), image.content)

  # Redirect the user to the index page
  return urbit.redirect("/")

# Start the app
app.start()
