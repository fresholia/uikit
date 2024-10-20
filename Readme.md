# UIKit for MTA:SA

## 1. Introduction ##

UIKit is a collection of user interface components for the server. It is designed to be a flexible and easy-to-use
solution for creating user interfaces in your scripts.

UIKit is designed to be modular and extensible. It provides a set of core components that can be used to create a wide
variety of UI elements, as well as a system for creating custom components. It also includes a number of utility
functions
for working with UI elements, such as layout management, event handling, and animation.

## 2. Installation ##

To install UIKit, simply copy the `uikit` folder to your `resources` directory and start the resource in your server.

### Steps: ###

1. Download the latest release.
2. Extract the contents of the archive to your `resources` directory.
3. Start the `uikit` resource in your server.
4. You're ready to start using UIKit in your scripts!

### Using UIKit in your scripts ###

To use UIKit in your scripts, you need to require the `uikit` module in your script.

1. Add this to the top line of the first running lua file of your script:

#### IMPORTANT: ####

OOP must be turned on, on your resource to use this module.

```lua
loadstring(exports.uikit:getModule())()
```

2. Import the component you want to use:

**Example:**

```lua
import('Window', 'Button')

local function createBasicWindow()
    local window = Window:new({ x = 0, y = 0 }, { x = 500, y = 500 }, 'Basic Window')
    window:toCenter()

    local closeButton = Button:new(
            Vector2(window.content.position.x, window.content.position.y),
            nil,
            'Close',
            Button.variants.Solid,
            Element.color.Primary,
            Element.size.Medium
    )
    closeButton:setParent(window)
    closeButton:createEvent(Element.events.OnClick, function()
        window:destroy()
        outputChatBox('Window closed!')
    end)
end
createBasicWindow()
```

**Note:** Components that you do not import using the import function will not work, you will get a small warning
message in the console.

3. Importing all components:

```lua
import('*')
```

**Note:** This is not recommended as it will import all components.

## 3. Wiki ##

The [Wiki](https://docs-uikit.gitbook.io/ui-kit) contains detailed documentation on how to use UIKit, including guides.

## 4. Links ##

* [Wiki](https://docs-uikit.gitbook.io/ui-kit)
* [GitHub](https://github.com/fresholia/uikit)
* [Discord](https://discord.gg/Psu56spwTs)

## 5. License ##

UIKit is released under the MIT License.
All source code is available on [GitHub](https://github.com/fresholia/uikit).

Basely developed by [Inception Game and Media Services Ltd](https://github.com/inceptionnet)
