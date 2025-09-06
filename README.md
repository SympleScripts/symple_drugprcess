# symple_drugprocess

A unique FiveM script that provides an immersive drug processing system, allowing players to break down large drug bricks into individual baggies through NPC interaction.

Preview : https://medal.tv/games/gta-v/clips/l2V4tpM5utq8XaYV_?invite=cr-MSw3R1osMzQ5ODgxOTk5&v=60

## Features

- **Interactive NPC System**: Find the Coffee Club Card to unlock exclusive drug processing services
- **Brick-to-Baggie Processing**: Convert large drug bricks into smaller, sellable portions
- **Customizable Items**: Fully open-source code allows for easy modification and addition of custom items
- **Immersive Gameplay**: Requires players to obtain specific items before accessing services
- **Modern Framework Support**: Built for current FiveM standards

## Requirements

- **QBCore Framework**: qbox
- **Database**: oxmysql
- **Targeting System**: ox_target
- **Inventory System**: ox_inventory

## Installation

1. Download the script and extract to your resources folder
2. Add the Coffee Club Card item to your ox_inventory items.lua:

```lua
["coffee_club"] = {
    label = "Coffee Club Card",
    weight = 0,
    stack = false,
    close = true,
    description = "Membership card for an exclusive club.",
    client = {
        image = "coffee_club.png",
    }
},
```

3. Copy the `coffee_club.png` image from the install folder to your ox_inventory images directory
4. Install the Bean Machine MLO from: https://www.gta5-mods.com/maps/mlo-bean-machine-fivem-sp
5. Add `ensure symple_drugprocess` to your server.cfg
6. Restart your server

## How to Use

1. **Obtain the Coffee Club Card**: Players must first acquire the Coffee Club Card item
2. **Locate the NPC**: Find the processing NPC at the Bean Machine location
3. **Interact**: With the Coffee Club Card in inventory, players can interact with the NPC
4. **Process**: Exchange drug bricks for individual baggies of your desired drug type

## Configuration

This script is fully open-source and customizable:

- **Add Custom Items**: Modify the script to include your own drug types and processing ratios
- **Change Requirements**: Adjust what items are needed to access the NPC
- **Customize Locations**: Move the processing location to fit your server's layout
- **Modify Exchanges**: Change the brick-to-baggie conversion rates

## MLO Information

This script is designed to work with the Bean Machine MLO, which provides the perfect setting for discreet drug processing operations. 

**MLO Download**: https://www.gta5-mods.com/maps/mlo-bean-machine-fivem-sp

## Support

Need help or have questions? Join our Discord community:

**Discord**: https://discord.gg/rX7bWcNm

This is an open-source project. Feel free to:
- Fork the repository
- Submit pull requests
- Report issues
- Suggest improvements

## License

This project is open-source. Please respect the original work when modifying or redistributing.

---

**Note**: This script is intended for roleplay purposes on FiveM servers. Ensure compliance with your server's rules and local regulations regarding content.
