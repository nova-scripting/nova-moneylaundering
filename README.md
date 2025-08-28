# nv-moneylaundering

A comprehensive money laundering script for FiveM servers with ESX and QBCore framework support. Features disguise system, vehicle spawning, multiple laundering locations, and anti-exploit protection.

## 🌟 Features

- **Multi-Framework Support**: Compatible with ESX and QBCore
- **Disguise System**: Players can change into disguise outfits to avoid detection
- **Vehicle Management**: Spawn and despawn work vehicles with proper validation
- **Multiple Laundering Locations**: 10+ different locations across the map
- **Anti-Exploit Protection**: Server-side validation and cooldown systems
- **Tax System**: Configurable tax rates for different job types
- **Discord Logging**: Webhook integration for laundering activities
- **Skill Check Minigame**: Interactive laundering process with ox_lib
- **Blip System**: Map markers for all interaction points

## 📋 Requirements

- FiveM Server
- ESX Legacy or QBCore Framework
- ox_lib (for skill checks and UI)

## 🚀 Installation

1. **Download the resource**
   ```
   nv-moneylaundering
   ```

2. **Place in your resources folder**
   ```
   resources/nv-moneylaundering/
   ```

3. **Add to server.cfg**
   ```cfg
   ensure nv-moneylaundering
   ```

4. **Configure the script**
   - Edit `config/config.lua` to match your server settings
   - Set up Discord webhook in `config/webhook.lua`
   - Adjust money types and tax rates as needed

5. **Restart your server**

## ⚙️ Configuration

### Framework Settings
```lua
Config.Framework = 'ESX'  -- Choose: ESX / QBCORE
```

### Money Laundering Settings
```lua
Config.WashDuration = 30000   -- Time required to launder money (ms)
Config.IllegalMoneyType = 'black_money' -- Type of dirty money
Config.LegalMoneyType = 'money' -- Type of clean money
Config.MoneyLimitations = { min = 10000, max = 1000000 } -- Min/max amounts
```

### Tax Settings
```lua
Config.StandardTaxRate = 0.50  -- Default tax rate (50%)
Config.GangTaxRate = 0.30      -- Tax rate for specific jobs (30%)
Config.GangJobs = {
    'police',  -- Jobs with different tax rate
}
```

### Location Configuration
The script includes 10+ pre-configured laundering locations across:
- Sandy Shores
- Paleto Bay
- Los Santos City
- Various highway locations

Each location includes:
- Door coordinates for entry
- Inside coordinates for the laundering area
- Laundering machine coordinates
- Custom interaction text

## 🎮 Usage

### For Players

1. **Start the Job**
   - Go to the main laundry location (marked on map)
   - Use the interaction menu to get disguised
   - Spawn a work vehicle

2. **Launder Money**
   - Drive to any laundering location
   - Enter the building through the marked door
   - Approach the laundering machine
   - Complete the skill check minigame
   - Wait for the laundering process to complete

3. **Complete the Job**
   - Return to the main location
   - Despawn the vehicle
   - Remove disguise to return to normal clothes

### For Administrators

- Monitor laundering activities through Discord webhooks
- Adjust tax rates and money limitations in config
- Add/remove laundering locations as needed
- Configure gang job tax rates

## 🔧 Customization

### Adding New Locations
```lua
{
    name = "Your Location Name",
    doorCoords = vector3(x, y, z),
    insideCoords = vector3(x, y, z),
    laundryCoords = vector3(x, y, z),
    interactText = "[E] Start Money Laundering"
}
```

### Custom Disguise Components
```lua
Config.maleComponents = {
    { 1,  0,   0 },   -- Masks
    { 3,  6,  0 },    -- Hands
    { 4,  34, 0 },    -- Pants
    -- Add more components as needed
}
```

### Vehicle Configuration
```lua
vehicle = {
    model = "burrito",
    plateText = "laundry",
    spawnCoords = vector4(x, y, z, heading)
}
```

## 🛡️ Security Features

- **Server-side validation**: All money operations validated server-side
- **Location verification**: Players must be at valid laundering locations
- **Cooldown system**: Prevents rapid laundering attempts
- **Vehicle validation**: Only allows spawning/despawning work vehicles
- **Anti-exploit measures**: Kicks players attempting to exploit the system

## 📊 Discord Logging

The script includes comprehensive Discord webhook logging:
- Player information and identifiers
- Amount of money laundered
- Tax applied and final amount
- Player job information
- Timestamp of activity

Configure in `config/webhook.lua`:
```lua
Webhook.URL = 'YOUR_DISCORD_WEBHOOK_URL'
```

## 🐛 Troubleshooting

### Common Issues

1. **Script not starting**
   - Check if ox_lib is installed and started
   - Verify framework compatibility
   - Check server console for errors

2. **Money not being removed/added**
   - Verify money type names match your framework
   - Check if player has sufficient funds
   - Ensure tax rates are properly configured

3. **Locations not working**
   - Verify coordinates are correct
   - Check if IPLs are loaded (if using custom interiors)
   - Ensure blips are enabled in config

### Debug Mode
Enable debug mode in config to see detailed console messages:
```lua
Config.DebugMode = true
```

## 📝 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 🤝 Support

- **Documentation**: [Nova Scripting GitBook](https://nova-scripting.gitbook.io/docs)
- **Tebex Store**: [Nova Scripting](https://nova-scripting.tebex.io/)
- **Issues**: Report bugs and feature requests on GitHub

## 🔄 Updates

Stay updated with the latest features and bug fixes by:
- Following the GitHub repository
- Checking the Tebex store for updates
- Reading the changelog in releases

## 📞 Credits

- **Developer**: Milo | Nova Scripts
- **Framework**: ESX & QBCore
- **Dependencies**: ox_lib

---

**Note**: This script is designed for roleplay servers. Ensure it complies with your server's rules and regulations.