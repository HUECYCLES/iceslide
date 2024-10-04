this library allows you to slide on ice, like in Undertale!
# Usage
- extract the folder from the .zip and plop the library into your mod's libraries folder.
- in your map, in the objects layer, make a rectangle and name it "icearea". you can add a string property to it named ``sound`` that will play a sound of your choice when you enter the event.
- have fun sliding!

# Notes
- the library has an option for adding custom sprites for the player and followers. if you want to use them, set use_custom_sprites in lib.json to true, and in your player/follower's actor folders, add a folder called iceslide, and inside of it add sprites named with different directions, like "left", "right", and so on. if false, the sprites used in the iceslide will default to the actor's default walk animation's second frame.
- the library also has an option for leaving an icetrail behind the player and playing a looping sound. you can enable it and change the sprites to your liking (which are found in ``effects/icetrail`` and ``effects/icetrail_b``) + choose a sound to play.
- this library does not check collisions. don't use it where you can collide with stuff. i don't think Undertale did it, so for now, i'm not gonna add collision checking.
