This library allows you to slide on ice, like in Undertale! With a few additions...

# Usage & Features
- Extract the folder from the .zip and simply plop the library into your project's ``libraries`` folder.
- In your map, in an ``objects`` layer, make a rectangle (or as many as you want) and name it "icearea".

> [!TIP]
> You can add a string property to it named ``sound`` that will play a sound of your choice whenever you enter the event.

## Custom Sprites
This library has an option for adding custom sprites or animations for the player and followers while sliding.

If you want to use them, set ``use_custom_sprites`` in lib.json to true, and in your player/follower's actor folders, add a folder called ``iceslide``. Inside of it, add sprites/animations named different directions, like ``left``, ``right``, and so on.

> [!NOTE]
> If false, the sprites used in the slide will pick and choose between the actor's default walk animation's second and fourth frame.

## IceTrail
There are a few config options involved in leaving a trail behind the player while sliding.
- ``trail``: If true, it will enable the trail.
- ``trailsprite``: String containing the path to the sprite you want to use in the trail effect.
- ``trailsprite_color``: Table with the RGB values for setting the sprite's color. Optional.
- ``trailsprite_initial_scale``: Number indicating the initial scale of the sprite for the effect. Optional, defaults to ``1.2``.
- ``use_trailsound``: If true, enables a looping sound that will play alongside the trail effect.
- ``trailsound``: String containing the path to the sound you want to use.

# Known Issues

- This library **does not check collisions**. Don't use it where you can collide with stuff. (I don't think Undertale did it, so for now, I'm not gonna add collision checking...)
