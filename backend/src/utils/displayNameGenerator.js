const adjectives = [
  "Crimson", "Emerald", "Silver", "Scarlet", "Obsidian", "Amber", "Midnight", "Radiant", "Vibrant", "Glimmering",
  "Shining", "Glow", "Luminous", "Bright", "Dusk", "Dawn", "Solar", "Lunar", "Stellar", "Nebula",
  "Galactic", "Astral", "Vortex", "Shattered", "Broken", "Iron", "Steel", "Bronze", "Copper", "Stone",
  "Rock", "Mountain", "River", "Ocean", "Wave", "Storm", "Thunder", "Lightning", "Wind", "Gale",
  "Blizzard", "Frost", "Glacier", "Ice", "Flame", "Blaze", "Ember", "Ash", "Pyro", "Hydro",
  "Aero", "Geo", "Terra", "Aqua", "Zephyr", "Breeze", "Whisper", "Echo", "Phantom", "Ghost",
  "Spirit", "Specter", "Wraith", "Ancient", "Primal", "Eternal", "Infinite", "Timeless", "Lost", "Hidden",
  "Secret", "Sacred", "Divine", "Holy", "Mystical", "Magical", "Arcane", "Enchanted", "Charmed", "Cursed",
  "Fierce", "Savage", "Noble", "Brave", "Bold", "Valiant", "Heroic", "Loyal", "Proud", "Grand",
  "Royal", "Imperial", "Majestic", "Regal", "Elite", "Prime", "Alpha", "Omega", "Apex", "Zenith",
  "Nimble", "Agile", "Quick", "Rapid", "Fleet", "Velo", "Sonic", "Hyper", "Super", "Mega",
  "Giant", "Titan", "Colossal", "Massive", "Mighty", "Strong", "Fierce", "Grim", "Stark", "Bleak",
  "Sleek", "Smooth", "Sharp", "Keen", "Clever", "Sly", "Cunning", "Wise", "Sage", "Elder",
  "Young", "Nova", "Neo", "Retro", "Vintage", "Classic", "Urban", "Neon", "Cyber", "Digital",
  "Matrix", "Quantum", "Sonic", "Acoustic", "Vocal", "Silent", "Quiet", "Calm", "Serene", "Placid"
];


const animals = [
  "Cheetah", "Leopard", "Jaguar", "Cougar", "Lynx", "Bobcat", "Ocelot", "Jackal", "Coyote", "Dingo",
  "Hyena", "Badger", "Wolverine", "Otter", "Weasel", "Ferret", "Mink", "Raccoon", "Panda", "Koala",
  "Wombat", "Wallaby", "Kangaroo", "Opossum", "Platypus", "Echidna", "Rhino", "Hippo", "Elephant", "Giraffe",
  "Zebra", "Camel", "Llama", "Alpaca", "Deer", "Elk", "Moose", "Caribou", "Reindeer", "Antelope",
  "Gazelle", "Impala", "Bison", "Buffalo", "Yak", "Bull", "Ram", "Goat", "Ibex", "Stag",
  "Horse", "Stallion", "Mustang", "Pony", "Donkey", "Mule", "Boar", "Pig", "Hedgehog", "Porcupine",
  "Squirrel", "Chipmunk", "Beaver", "Gopher", "Marmot", "Lemming", "Meerkat", "Mongoose", "Lemur", "Gibbon",
  "Chimpanzee", "Gorilla", "Orangutan", "Baboon", "Macaque", "Sloth", "Armadillo", "Anteater", "Bat", "Vampire",
  "Owl", "Raven", "Crow", "Magpie", "Jay", "Cardinal", "Robin", "Finch", "Sparrow", "Swallow",
  "Swift", "Martin", "Lark", "Thrush", "Mockingbird", "Wren", "Warbler", "Oriole", "Tanager", "Grosbeak",
  "Condor", "Vulture", "Buzzard", "Harrier", "Osprey", "Kestrel", "Merlin", "Gyrfalcon", "Caracara", "Kite",
  "Heron", "Egret", "Stork", "Ibis", "Spoonbill", "Flamingo", "Pelican", "Cormorant", "Gannet", "Booby",
  "Swan", "Goose", "Duck", "Teal", "Merganser", "Loon", "Grebe", "Penguin", "Puffin", "Albatross",
  "Gull", "Tern", "Skua", "Auk", "Murre", "Petrel", "Shearwater", "Frigatebird", "Tropicbird", "Crane",
  "Rail", "Coot", "Gallinule", "Bustard", "Plover", "Sandpiper", "Snipe", "Curlew", "Godwit", "Avocet"
];


function generateDisplayName(){
    const  adjective = 
        adjectives[Math.floor(Math.random()*adjectives.length)];
    const animal = 
        animals[Math.floor(Math.random()*animals.length)];
    
    const number= Math.floor(Math.random()*900)+100;
    return `${adjective}${animal}${number}`;
}
// console.log(genrateDisplayName());
module.exports={
  generateDisplayName
}