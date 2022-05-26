# Made By Wakie Modifications (Discord Server: https://discord.gg/CY9tg5dAPP)
**You are permitted to modify & re-configure this script. You are not permitted to sell this script and or rip this script, You must provide proper credit to the developer of this script (Wakie Modifications)**

# Description
An advanced vehiclerentals script for the QBCore Framework, that is optimized, and can be easily configured to your liking.

# Features
1. Everything is easily configurable including localization!
2. You can have multiple rental locations, that are for either land, air, or water. You can also have custom peds, scenarios, and blips for each location.
3. You can have multiple rentable vehicles, for each catagory such as land, air, or water.
4. A player will be charged the rental fee for that certain vehicle after each rental fee interval. (Adding More Realism)
5. If a rental vehicle has been destroyed during the rent, the player will recieve an additional fee charged to their bank account.
6. A player cannot get another rental vehicle, until the previous rental vehicle has been returned.
7. A player can return a rental at any configured location.
8. The player will receive a rental certificate with all the important information.
9. The player can either return or rent a car through the third eye on the ped.
10. Players can either pay for the rental from their cash or bank. If they have no money but still have an outstanding rental vehicle, they will then be charged from their bank account.
11. If a player return a damaged rental, they will get an additional charge.

# Update 1.1
1. Checks if a rental vehicle is underwater. (May Be a little buggy?) (Automatically ignores all rental boats)
2. Added ability to have different peds and scenarios for each location.
3. Added ability to customize blips for each location.
4. Added In three new rentable categories such as Land, Air, and Water. (You can customize each location to have either one of these rentable categories.) 
5. Added In a feature to charge players a fee if they return a rental vehicle damaged. (Check Config for more info)

# Dependencies 
1. [QBCore](https://github.com/qbcore-framework/qb-core)
2. [QB-Target](https://github.com/qbcore-framework/qb-target)
3. [QB-Inventory](https://github.com/qbcore-framework/qb-inventory) (Or Similar)
4. [LegacyFuel](https://github.com/InZidiuZ/LegacyFuel) (Or Similar, Changeable Through The Config)
5. [QB-Menu](https://github.com/qbcore-framework/qb-menu)

# Script Preformance
While Running In The Background: 0.00ms CPU Usage
While Usage Of The Script: 0.00ms - 0.01 CPU Usage

# Installation Steps

1. Drag & Drop wm-vehiclerentals into your resource folder.

2. Add 'ensure wm-vehiclerentals' in your Server.cfg (Don't do this, if you have put the wm-vehiclerentals resource in a folder that is already ensured in your cfg file.)

3. Paste the following in your QBCore > Shared > Items.Lua (Ex. https://gyazo.com/347bfe6c898555b98b9c7762120a4475)

``` json
	['rentcertificate'] = {['name'] = 'rentcertificate', 			  	  	['label'] = 'Rental Certificate', 				['weight'] = 0, 		['type'] = 'item', 		['image'] = 'certificate.png', 			['unique'] = true, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Certificate that proves you own a rental vehicle'},
```

4. Paste the following in your QB-Inventory (Or Similar) > HTML > JS > App.JS > Line 420 (Ex. https://gyazo.com/30c3d19004e656c436f771b3e9e445d5)

``` json
} else if (itemData.name == "rentcertificate") {
                $(".item-info-title").html("<p>" + itemData.label + "</p>");
                $(".item-info-description").html(
                    "<p><strong>Rentees First Name: </strong><span>" +
                    itemData.info.firstname +
                    "</span></p><p><strong>Rentees Last Name: </strong><span>" +
                    itemData.info.lastname +
                    "</span></p><p><strong>Vehicle Model: </strong><span>" +
                    itemData.info.vehicle +
                    "</span></p><p><strong>Vehicle License Plate: </strong><span>" +
                    itemData.info.vehicleplate +
                    "</span></p>"
                );
```

5. Your done, Enjoy the script! If you require any assistance or have any questions feel free to create a support ticket in our discord server!